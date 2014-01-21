Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaAUNcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:32:53 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:47001 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbaAUNcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:32:51 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZW-Nay-wOywq4SG1bwQf_+J4tqYuS=tQmzTHOtBskGVw@mail.gmail.com>
References: <1384270261-15889-1-git-send-email-linus.walleij@linaro.org>
	<20131126023431.GC31517@core.coreip.homeip.net>
	<CACRpkdZW-Nay-wOywq4SG1bwQf_+J4tqYuS=tQmzTHOtBskGVw@mail.gmail.com>
Date: Tue, 21 Jan 2014 14:32:50 +0100
Message-ID: <CACRpkdab32Cfj73D5zyVLDr9JTsQ2xxS3kDKjTBi4f+vLtZMAw@mail.gmail.com>
Subject: Re: [PATCH 4/5 v3] input: tc3589x-keypad: support probing from device tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 2:28 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Nov 26, 2013 at 3:34 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>> On Tue, Nov 12, 2013 at 04:31:01PM +0100, Linus Walleij wrote:
>>>       irq = platform_get_irq(pdev, 0);
>>> --
>>
>> Don't you also want to add MODULE_DEVICE_TABLE entry?
>
> Probably, but that'd be a separate subject though, I think?
> I'll make a patch for this so you get something you can
> actually merge.

No, wait, this driver only matches on driver name, it has no
match table of any kind. This is typical for MFD-spun cells
if they don't need additional info from the compat match.
I think it only needs the MODULE_ALIAS() it already
has.

Yours,
Linus Walleij
