Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3CLTRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:17:34 -0400
Received: from mail.tpi.com ([70.99.223.143]:3445 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183Ab3CLTRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:17:33 -0400
Message-ID: <513F7F46.3050200@canonical.com>
Date: Tue, 12 Mar 2013 13:17:26 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        device-drivers-devel@blackfin.uclinux.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH linux-next v2] ASoC: adau1373: adau1373_hw_params: Silence
 overflow warning
References: <513E2895.6040904@metafoo.de> <1363029503-23880-1-git-send-email-tim.gardner@canonical.com> <20130312184741.GP19942@opensource.wolfsonmicro.com>
In-Reply-To: <20130312184741.GP19942@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 03/12/2013 12:47 PM, Mark Brown wrote:
> On Mon, Mar 11, 2013 at 01:18:23PM -0600, Tim Gardner wrote:
>> ADAU1373_BCLKDIV_SOURCE is defined as BIT(5) which uses UL
>> constants. On amd64 the result of the ones complement operator is
>> then truncated to
> 
> Applied, but please don't bury patches in the middle of e-mail
> threads (I nearly deleted this unread) and avoid including
> 

Point taken. In the future I'll start a new thread for each v(n).

>> Cc: Lars-Peter Clausen <lars@metafoo.de> Cc: Liam Girdwood
>> <lgirdwood@gmail.com> Cc: Mark Brown
>> <broonie@opensource.wolfsonmicro.com> Cc: Jaroslav Kysela
>> <perex@perex.cz> Cc: Takashi Iwai <tiwai@suse.de> Cc:
>> device-drivers-devel@blackfin.uclinux.org Cc:
>> alsa-devel@alsa-project.org Signed-off-by: Tim Gardner
>> <tim.gardner@canonical.com>
> 
> enormous CC lists like this in the body of the mail.
> 

I'm just going by the default output of scripts/get_maintainer.pl. Are
there better options to filter the roles ? In this case I received a
review from a supporter (Lars), and the patch is being committed by
yet another supporter (yourself). Would you have noticed this patch
had I restricted the Cc list to just maintainers and lists ?

Lars-Peter Clausen <lars@metafoo.de> (supporter:ANALOG DEVICES IN...)
Liam Girdwood <lgirdwood@gmail.com> (supporter:SOUND - SOC LAYER...)
Mark Brown <broonie@opensource.wolfsonmicro.com> (supporter:SOUND -
SOC LAYER...)
Jaroslav Kysela <perex@perex.cz> (maintainer:SOUND)
Takashi Iwai <tiwai@suse.de> (maintainer:SOUND)
device-drivers-devel@blackfin.uclinux.org (open list:ANALOG DEVICES IN...)
alsa-devel@alsa-project.org (moderated list:ANALOG DEVICES IN...)
linux-kernel@vger.kernel.org (open list)

rtg
- -- 
Tim Gardner tim.gardner@canonical.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCgAGBQJRP38/AAoJED12yEX6FEfKppEP/jAi6jFpqKwNF3KPiH4j7E9m
PYiydQTVHxgHlqzhJw+7+hyfz7fgbDSew0BpC84gtUYp2xcqCePkNoExT8COk08U
wzIVm6Z1OT57RZDBMoICcH/Xm9/Y2/cf4eXOgiEw5tfP25Gwae2Vep9NcHkCz3iA
4XNg+Cpq+Bu+l4f0WTTUmZlJmhbuai/knEodz413hIHXOhAXLe/ZnMSE2wh9/UnD
H17z7pijKcAMAtcYJmLGT928U2rereW4rlR3+jh9k7CQ4wADo8XrJHNVXo7fgS4Q
ws7hTWsaMuDTXKvg6fWbD9uMJc3OFodZ/ig0uEbZz7LXoxQd1M8MywJnInz6mGBQ
9UnSg4AZOqs64Hm9X98902Fzro8dAa0ltjyPCxYgFhuORG86+SFseS514Y8aYWS8
3/fdgR/kb4kNK4Zd+bDZv34/IEeIJiXlkUshIbhc58ErzVKP54shova2793UVcOk
f5JmM7Tx/ctm2jzj3NYUS6HUsXucaE1K6HSPZ5qJlZyk6s59jJJwNWTILkwNu3Nj
qxlPLWlRcyY8QuPQILx5podOhDmmAduPc8VOVF0YRed+J39BHJRVer3k/i2S/jkz
ACULLlA6edESk3/poeGdBP1S0UhuI3PlzMh9Kwkkx6O8r8COgNVa1hfBSc6DAj+i
YRSlhhPGE022ZQ6VhKUf
=VhzH
-----END PGP SIGNATURE-----
