Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3A1U4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 15:56:52 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:56053 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab3A1U4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:56:48 -0500
MIME-Version: 1.0
In-Reply-To: <201301282016.BAG95395.VMOFFFQSHLOtJO@I-love.SAKURA.ne.jp>
References: <1359328750-28046-1-git-send-email-linus.walleij@linaro.org>
	<201301282016.BAG95395.VMOFFFQSHLOtJO@I-love.SAKURA.ne.jp>
Date: Mon, 28 Jan 2013 21:56:47 +0100
Message-ID: <CACRpkda-JsW05dyEbxAM3CiPjpErBWgq8YZyt2hzGV1qxhaBgg@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: versatile: fix the PCI IRQ regression
From: Linus Walleij <linus.walleij@linaro.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 12:16 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:

> Linus Walleij wrote:
>> ---
>> ChangeLog v1->v2:
>> - Got the PIC/SIC valid mask wrong again, take a deep breath
>>   and use the foolproof method of defining each bit so that
>>   nobody will get caught by this again. Didn't see this first
>>   because the SCSI layer takes for ever to time out.
>> ---
>>  arch/arm/mach-versatile/core.c | 15 ++++++++++++++-
>>  arch/arm/mach-versatile/pci.c  | 11 ++++++-----
>>  2 files changed, 20 insertions(+), 6 deletions(-)
>>
>
> This patch fixes my problem. Please send to 3.8. Thank you!

OK will put this into Russell's patch tracker, thanks!

Yours,
Linus Walleij
