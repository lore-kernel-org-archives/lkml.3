Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab3BRIzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 03:55:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:51409 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705Ab3BRIzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:55:24 -0500
Date: Mon, 18 Feb 2013 09:55:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@openvz.org>
cc: Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, paul.gortmaker@windriver.com,
        davej@redhat.com, keescook@chromium.org, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: + futex-avoid-kernel-taint-caused-by-get_robust_list.patch added
 to -mm tree
In-Reply-To: <20130216070240.GA20312@moon>
Message-ID: <alpine.LFD.2.02.1302180949240.22263@ionos>
References: <20130215222653.B8B115A41F0@corp2gmr1-2.hot.corp.google.com> <20130215234444.29345fc3@spider.haslach.nod.at> <20130216070240.GA20312@moon>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2013, Cyrill Gorcunov wrote:

> On Fri, Feb 15, 2013 at 11:44:44PM +0100, Richard Weinberger wrote:
> > > The ability to deprecate this code has been called into question[1],
> > > but if that remains to be finalized, then making this change in the
> > > interim seems to make sense.
> > 
> > Do we really want to remove this system call in 2013?
> > Note, Documentation/feature-removal-schedule.txt is gone...
> > 
> > CRIU folks, I guess you still need the call?
> > Or have you found an alternative way to get the robost list?
> 
> Yes, we need this call and we use it.
> 
> > As stated in [0], I'd simply revert commit ec0c4274 ("futex: Mark
> > get_robust_list as deprecated")
> 
> Thanks!

I take the revert via tip and queue it for 3.9

Thanks,

	tglx
 
