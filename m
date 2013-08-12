Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab3HLN6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:58:48 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:29448 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab3HLN6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:58:47 -0400
Date: Mon, 12 Aug 2013 08:58:45 -0500
From: scameron@beardog.cce.hp.com
To: John Kacur <jkacur@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Clark Williams <williams@redhat.com>, scameron@beardog.cce.hp.com
Subject: Re: [PATCH] hpsa: fix warning with smp_processor_id() in preemptible
Message-ID: <20130812135845.GA15147@beardog.cce.hp.com>
References: <alpine.LFD.2.03.1307261640170.2642@tycho> <20130812131312.GF23040@linutronix.de> <1290115203.630841.1376314412366.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290115203.630841.1376314412366.JavaMail.root@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 09:33:32AM -0400, John Kacur wrote:
> 
> 
> ----- Original Message -----
> > * John Kacur | 2013-07-26 16:42:30 [+0200]:
> > 
> > >Signed-off-by: John Kacur <jkacur@redhat.com>
> > >Acked-by: Stephen <scameron@beardog.cce.hp.com>
> > 
> > ping.
> > 
> > I checked the branches for-next, scsi-fixes, fixes and misc at [0] and I
> > didn't see it. I'm going to take this for 3.10-rt but please don't lose
> > it on its way to Linus :)
> > 
> > [0] git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
> 
> 
> I hope it was clear to everyone that this patch was intended for upstream.
> It was discovered by running the real-time kernel, but it exposes a (minor) problem
> that should be fixed in the mainline kernel. Please apply it there Stephen, and
> push it upstream appropriately.

I don't have such pushing abilities.  Acking it as I've done is
all I can do.  Bug James. :)

-- steve

