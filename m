Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbaGVMMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:12:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:32818 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755044AbaGVMMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:12:22 -0400
Date: Tue, 22 Jul 2014 14:12:19 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, Lee Jones <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mtd: nand: define struct nand_timings
Message-ID: <20140722141219.7f2c2890@bbrezillon>
In-Reply-To: <20140722120346.0f2d0e77@parrot.com>
References: <1405064982-11456-1-git-send-email-boris.brezillon@free-electrons.com>
	<1405064982-11456-2-git-send-email-boris.brezillon@free-electrons.com>
	<20140722120346.0f2d0e77@parrot.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthieu

On Tue, 22 Jul 2014 12:03:46 +0200
Matthieu CASTET <matthieu.castet@parrot.com> wrote:

> Hi,
> 
> 
> Do you know if all these timings will be used by the nand drivers ?

I don't know (it depends on each NAND controller), and this is exactly
why I decided to define all the timings described in the ONFI
specification [1]. 

> 
> I did a similar patch [1] (that wasn't merged :( ), and I used reduced
> timing info.

I'm sorry it didn't make it to mainline, do you know why ?
Could you point out where "reduced timing info" is defined in the ONFI
specification ?

> 
> I also have support for the omap driver
> (http://article.gmane.org/gmane.linux.ports.arm.omap/88606/match=) and
> a controller we use in our chip (not upstream).

It should be pretty easy to convert the full timings list into a
reduced one (actually, that's what your patch is doing), and you can
thus port your work on top of these patches.

Anyway, I'm not sure what you have in mind, but unless there is a strong
reason to drop full timings in favor of reduced ones I'd like to
keep them (even if this implies adding a new converter to get reduced
timings list).

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
