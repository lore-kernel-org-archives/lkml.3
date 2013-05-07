Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577Ab3EGJb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:31:29 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:6658 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759378Ab3EGJb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:31:27 -0400
Message-ID: <5188C9EC.7000303@atmel.com>
Date: Tue, 7 May 2013 11:31:24 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
CC: Mark Brown <broonie@kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Grant Likely <grant.likely@linaro.org>,
        "Richard Genoud" <richard.genoud@gmail.com>,
        Joachim Eastwood <manabian@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after xfer->speed_hz
 set
References: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com> <1362626815-6628-1-git-send-email-wenyou.yang@atmel.com> <CAGhQ9VwW18LXY5Jn0FUFCaAzKxP1W3QADG=JBp9JbgaAwo=F2Q@mail.gmail.com> <B256D81BAE5131468A838E5D7A24364154236AB5@penmbx02> <CACQ1gAhZO3stjrwf5SiZf7jOO8T5bAJZiz97M7+7vwFmk2e65g@mail.gmail.com> <5182414F.1000201@atmel.com> <20130506103105.GB13472@opensource.wolfsonmicro.com> <B256D81BAE5131468A838E5D7A24364154238AF5@penmbx02>
In-Reply-To: <B256D81BAE5131468A838E5D7A24364154238AF5@penmbx02>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 03:11, Yang, Wenyou :
> Hi, Mark
> 
>> From: Mark Brown [mailto:broonie@kernel.org]
>> Sent: 2013Äê5ÔÂ6ÈÕ 18:31
>> To: Ferre, Nicolas
>> Cc: grant.likely@secretlab.ca; Grant Likely; Richard Genoud; Yang, Wenyou;
>> Joachim Eastwood; linux-arm-kernel@lists.infradead.org;
>> plagnioj@jcrosoft.com; Lin, JM; spi-devel-general@lists.sourceforge.net;
>> linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after
>> xfer->speed_hz set
>>
>> On Thu, May 02, 2013 at 12:34:55PM +0200, Nicolas Ferre wrote:
>>
>>> Can you tell us if this SPI patch will be merged upstream using one of
>>> your paths?
>>
>> I have no idea what patch this is but if it's not in my tree -next it's unlikely to be
>> merged.
> This is dropped patch, no need to be merged.
> 
> We tested Atmel spi in your tree-next , but it doesn't work, the reason is the Joachim Eastwood's patch is not included.
> https://patchwork.kernel.org/patch/2165301/
> which Joachim said that Grant said he applied.

Hi Wenyou,

Sorry for not having communicating with you after Mark told me the story
about this patch: Mark merged Grant's material in his SPI tree (with is
the official one nowadays). You can see that by browsing linux-next:

 Merge remote-tracking branch 'spi/fix/grant' into spi-linus

Joachim's patch is well included in it. We still have to monitor
inclusion of it in Linus' tree...

Mark, sorry for the noise.

Bye,
-- 
Nicolas Ferre
