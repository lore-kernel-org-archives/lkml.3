Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaBXOqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:46:19 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:36767 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaBXOqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:46:17 -0500
MIME-Version: 1.0
In-Reply-To: <530247FC.90606@infradead.org>
References: <20140217172329.2c61499f57842ec2ed177bc5@canb.auug.org.au>
	<530247FC.90606@infradead.org>
Date: Mon, 24 Feb 2014 15:46:17 +0100
Message-ID: <CACRpkdamW1-CxZV65at3PaPhY5nANRDd=SY=FsNPVnrPxyD81w@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 17 (pinctrl-msm)
From: Linus Walleij <linus.walleij@linaro.org>
To: Randy Dunlap <rdunlap@infradead.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 6:33 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 02/16/2014 10:23 PM, Stephen Rothwell wrote:
>> Hi all,
>>
>> If you see failures in building this tree due to missing declarations of
>> k..alloc/free, then it may be caused by commit 2bd59d48ebfb ("cgroup:
>> convert to kernfs").  Please send Tejun Heo <tj@kernel.org> a patch
>> adding an inclusion of linux/slab.h to the appropriate file(s).
>>
>> This tree fails (more than usual) the powerpc allyesconfig build.
>>
>> Changes since 20140214:
>>
>
> on i386:
>
> ERROR: "handle_bad_irq" [drivers/pinctrl/pinctrl-msm.ko] undefined!

Weird, Björn do you know what may be causing this?

Yours,
Linus Walleij
