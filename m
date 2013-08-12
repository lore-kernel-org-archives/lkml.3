Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab3HLNNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:13:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:44237 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab3HLNNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:13:16 -0400
Date: Mon, 12 Aug 2013 15:13:12 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Stephen Cameron <scameron@beardog.cce.hp.com>,
        linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH] hpsa: fix warning with smp_processor_id() in
 preemptible
Message-ID: <20130812131312.GF23040@linutronix.de>
References: <alpine.LFD.2.03.1307261640170.2642@tycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1307261640170.2642@tycho>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* John Kacur | 2013-07-26 16:42:30 [+0200]:

>Signed-off-by: John Kacur <jkacur@redhat.com>
>Acked-by: Stephen <scameron@beardog.cce.hp.com>

ping.

I checked the branches for-next, scsi-fixes, fixes and misc at [0] and I
didn't see it. I'm going to take this for 3.10-rt but please don't lose
it on its way to Linus :)

[0] git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git

Sebastian
