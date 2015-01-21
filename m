Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbbAUI2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:28:08 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:38836 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbbAUI15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:27:57 -0500
X-ME-Helo: beldin
X-ME-Date: Wed, 21 Jan 2015 09:27:56 +0100
X-ME-IP: 109.222.126.211
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Lee Jones <lee.jones@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH v3 2/3] mfd: lubbock_io: add lubbock_io board
References: <1421406010-14851-1-git-send-email-robert.jarzmik@free.fr>
	<1421406010-14851-2-git-send-email-robert.jarzmik@free.fr>
	<20150119091705.GG21886@x1> <87ppaah9k5.fsf@free.fr>
	<20150120102919.GP5767@x1>
	<20150120115658.GJ26493@n2100.arm.linux.org.uk>
	<873874fuei.fsf@free.fr> <20150121081645.GC9258@x1>
X-URL: http://belgarath.falguerolles.org/
Date: Wed, 21 Jan 2015 09:27:54 +0100
In-Reply-To: <20150121081645.GC9258@x1> (Lee Jones's message of "Wed, 21 Jan
	2015 08:16:45 +0000")
Message-ID: <87y4owedx1.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Jones <lee.jones@linaro.org> writes:

> On Wed, 21 Jan 2015, Robert Jarzmik wrote:
>> > > > platform_get_irq()?
>> > > No. I need the flags.
>> > Where are they used?
>> A couple of lines below, using local "irqflags" variable :
>>        ret = devm_request_irq(&pdev->dev, cot->irq, lubbock_irq_handler,
>>                               irqflags, dev_name(&pdev->dev), cot);
>
> No, I mean where are they _used_?
I don't get your point.

For you, isn't it "using" irqflags by passing them as an argument to devm_request_irq()
??? And if you think ahead, then there are used all around in
kernel/irq/manage.c, as you probably know.

Cheers.

-- 
Robert
