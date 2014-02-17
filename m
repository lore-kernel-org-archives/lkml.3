Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaBQRdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:33:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48208 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaBQRdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:33:51 -0500
Message-ID: <530247FC.90606@infradead.org>
Date: Mon, 17 Feb 2014 09:33:48 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for Feb 17 (pinctrl-msm)
References: <20140217172329.2c61499f57842ec2ed177bc5@canb.auug.org.au>
In-Reply-To: <20140217172329.2c61499f57842ec2ed177bc5@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2014 10:23 PM, Stephen Rothwell wrote:
> Hi all,
> 
> If you see failures in building this tree due to missing declarations of
> k..alloc/free, then it may be caused by commit 2bd59d48ebfb ("cgroup:
> convert to kernfs").  Please send Tejun Heo <tj@kernel.org> a patch
> adding an inclusion of linux/slab.h to the appropriate file(s).
> 
> This tree fails (more than usual) the powerpc allyesconfig build.
> 
> Changes since 20140214:
> 

on i386:

ERROR: "handle_bad_irq" [drivers/pinctrl/pinctrl-msm.ko] undefined!


-- 
~Randy
