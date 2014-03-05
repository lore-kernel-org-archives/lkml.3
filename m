Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbaCEAji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:39:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:38358 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbaCEAjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:39:36 -0500
Date: Wed, 5 Mar 2014 01:39:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Khalid Aziz <khalid.aziz@oracle.com>
cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        peterz@infradead.org, akpm@linux-foundation.org, andi.kleen@intel.com,
        rob@landley.net, viro@zeniv.linux.org.uk, oleg@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
In-Reply-To: <5316574F.6040105@oracle.com>
Message-ID: <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014, Khalid Aziz wrote:
> be in the right control group. Besides they want to use a common mechanism
> across multiple OSs and pre-emption delay is already in use on other OSs. Good
> idea though.

Well, just because preemption delay is a mechanism exposed by some
other OS does not make it a good idea.

In fact its a horrible idea.

What you are creating is a crystal ball based form of time bound
priority ceiling with the worst user space interface i've ever seen.

Thanks,

	tglx
