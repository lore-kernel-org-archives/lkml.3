Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaGHKI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:08:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:54704 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbaGHKI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:08:56 -0400
Date: Tue, 8 Jul 2014 12:08:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fengguang Wu <fengguang.wu@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>
Subject: Re: [timer] BUG: soft lockup - CPU#1 stuck for 23s! [swapper/0:1]
In-Reply-To: <20140708034521.GD17142@localhost>
Message-ID: <alpine.DEB.2.10.1407081208060.4357@nanos>
References: <20140708034521.GD17142@localhost>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014, Fengguang Wu wrote:

> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit 1ead65812486cda65093683a99b8907a7242fa93
> Merge: b6d739e b97f029
> Author:     Linus Torvalds <torvalds@linux-foundation.org>
> AuthorDate: Tue Apr 1 11:00:07 2014 -0700
> Commit:     Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Tue Apr 1 11:00:07 2014 -0700

That's not really helpful. It's a merge commit, so we'd need to drill
down the bisect into what got merged.

Thanks,

	tglx
