Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab3HLNer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:34:47 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:33857 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab3HLNep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:34:45 -0400
Date: Mon, 12 Aug 2013 09:33:32 -0400 (EDT)
From: John Kacur <jkacur@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Stephen Cameron <scameron@beardog.cce.hp.com>,
        linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Clark Williams <williams@redhat.com>
Message-ID: <1290115203.630841.1376314412366.JavaMail.root@redhat.com>
In-Reply-To: <20130812131312.GF23040@linutronix.de>
References: <alpine.LFD.2.03.1307261640170.2642@tycho> <20130812131312.GF23040@linutronix.de>
Subject: Re: [PATCH] hpsa: fix warning with smp_processor_id() in
 preemptible
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF22 (Linux)/8.0.3_GA_5664)
Thread-Topic: hpsa: fix warning with smp_processor_id() in preemptible
Thread-Index: p4hcnbSKQi58494tLr/DBQYU9KpE3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> * John Kacur | 2013-07-26 16:42:30 [+0200]:
> 
> >Signed-off-by: John Kacur <jkacur@redhat.com>
> >Acked-by: Stephen <scameron@beardog.cce.hp.com>
> 
> ping.
> 
> I checked the branches for-next, scsi-fixes, fixes and misc at [0] and I
> didn't see it. I'm going to take this for 3.10-rt but please don't lose
> it on its way to Linus :)
> 
> [0] git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git


I hope it was clear to everyone that this patch was intended for upstream.
It was discovered by running the real-time kernel, but it exposes a (minor) problem
that should be fixed in the mainline kernel. Please apply it there Stephen, and
push it upstream appropriately.

Thank You.

John Kacur
