Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab3CLNbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:31:11 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41440 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3CLNbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:31:10 -0400
MIME-Version: 1.0
In-Reply-To: <201303121118.55770.arnd@arndb.de>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
 <1363083150-30964-18-git-send-email-acourbot@nvidia.com> <201303121118.55770.arnd@arndb.de>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 12 Mar 2013 22:30:49 +0900
Message-ID: <CAAVeFuKPaopR_5tSSVS_W+USn=qx2VChcb_B2CZTunWaJzwJ=A@mail.gmail.com>
Subject: Re: [RFC 17/17] unicore32: default GENERIC_GPIO to false
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 8:18 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 12 March 2013, Alexandre Courbot wrote:
>> @@ -24,7 +24,7 @@ config UNICORE32
>>           Please see web page at <http://www.pkunity.com/>.
>>
>>  config GENERIC_GPIO
>> -       def_bool y
>> +       def_bool n
>>
>
> "def_bool n" is the same as "bool", but in general the latter syntax is preferred.

I have fixed this for unicore32, but a few other architectures use the
"def_bool n" syntax consistently across their Kconfig, so for
consistency reasons it is maybe preferable to leave it that way for
them.

Alex.
