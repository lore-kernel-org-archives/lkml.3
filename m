Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaBYJjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:39:53 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:37663 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaBYJjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:39:47 -0500
MIME-Version: 1.0
In-Reply-To: <20140224184120.GB18563@joshc.qualcomm.com>
References: <20140217172329.2c61499f57842ec2ed177bc5@canb.auug.org.au>
	<530247FC.90606@infradead.org>
	<CACRpkdamW1-CxZV65at3PaPhY5nANRDd=SY=FsNPVnrPxyD81w@mail.gmail.com>
	<20140224174646.GA32621@sonymobile.com>
	<530B8C15.50100@infradead.org>
	<20140224184120.GB18563@joshc.qualcomm.com>
Date: Tue, 25 Feb 2014 10:39:46 +0100
Message-ID: <CACRpkdZbqwbknwoet_wFB8pTD4zoc5RTuU-BP9fcGefOiSJgSQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 17 (pinctrl-msm)
From: Linus Walleij <linus.walleij@linaro.org>
To: Josh Cartwright <joshc@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 7:41 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> On Mon, Feb 24, 2014 at 10:14:45AM -0800, Randy Dunlap wrote:

> Without too much effort, I can get this to fail just by making
> CONFIG_PINCTRL_MSM=m.  handle_bad_irq isn't marked EXPORT_SYMBOL*, so
> hence the warning.
>
> Whether or not this is intentional is not clear.  Do we support modules
> installing chained irq handlers?

That is a good question to tglx/Grant ...

As the kernel looks today, drivers installing chained handlers
cannot be modules, and that is it.

Yours,
Linus Walleij
