Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab3HGIUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:20:46 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:37389 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab3HGIUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:20:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130806171156.GN6427@sirena.org.uk>
References: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com>
 <1375180329-4860-3-git-send-email-richard.genoud@gmail.com> <20130806171156.GN6427@sirena.org.uk>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 7 Aug 2013 10:20:20 +0200
Message-ID: <CACQ1gAhVfSV1MArzTGxSfJOcEksBv-O2AjVJm6eEoBGtggw5uA@mail.gmail.com>
Subject: Re: [PATCH v6 2/8] ASoC: atmel: machine driver for at91sam9x5-wm8731 boards
To: Mark Brown <broonie@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Bo Shen <voice.shen@atmel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/6 Mark Brown <broonie@kernel.org>:
> On Tue, Jul 30, 2013 at 12:32:03PM +0200, Richard Genoud wrote:
>> From: Nicolas Ferre <nicolas.ferre@atmel.com>
>>
>> Description of the Asoc machine driver for an at91sam9x5 based board
>> with a wm8731 audio DAC. Wm8731 is clocked by a crystal and used as a
>> master on the SSC/I2S interface. Its connections are a headphone jack
>> and an Line input jack.
>
> Applied, thanks.  We should really be able to merge this with the
> sam9g20ek driver that's here already but we can do that later.

I think it will be easier after the switch to the common clock framework.
I'll look into that.

Thanks !
