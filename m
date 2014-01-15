Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaAOHji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 02:39:38 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:57758 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAOHjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 02:39:35 -0500
MIME-Version: 1.0
In-Reply-To: <1389207661.10754.42.camel@host5.omatika.ru>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
	<1387309071-22382-1-git-send-email-ynvich@gmail.com>
	<1387309071-22382-12-git-send-email-ynvich@gmail.com>
	<CACRpkdaY7xpoeeUqBBqUS2swe6Y5gKt67VYNvNRrsbFhyU=ATw@mail.gmail.com>
	<1389207661.10754.42.camel@host5.omatika.ru>
Date: Wed, 15 Jan 2014 08:39:35 +0100
Message-ID: <CACRpkda_6P3s3LBwV5ve+=_JhxehephvpPT=pKPk3NzEKQLa9g@mail.gmail.com>
Subject: Re: [PATCH v3 11/21] ARM: pxa: support ICP DAS LP-8x4x FPGA irq
From: Linus Walleij <linus.walleij@linaro.org>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 8:01 PM, Sergei Ianovich <ynvich@gmail.com> wrote:
> On Thu, 2014-01-02 at 13:32 +0100, Linus Walleij wrote:
>> On Tue, Dec 17, 2013 at 8:37 PM, Sergei Ianovich <ynvich@gmail.com> wrote:
>> Usually combined GPIO+IRQ controllers are put into drivers/gpio but
>> this is a bit special as it seems to handle also non-GPIO-related IRQs
>> so let's get some input on this.
>
> This one is a plain IRQ controller. It has simple input lines, not GPIO
> pins. The chip reports its status to upper level interrupt controller.
> The upper level controller is PXA GPIO in this case.

Hm I don't know why I was deluded into thinking this had something to
do with GPIO. I must have been soft in the head. Sorry about all those
comments ...

I'll re-read the irqchip driver v3.1.

Yours,
Linus Walleij
