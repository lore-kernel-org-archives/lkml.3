Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab3LOP2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 10:28:43 -0500
Received: from www.linutronix.de ([62.245.132.108]:55775 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3LOP2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 10:28:42 -0500
Date: Sun, 15 Dec 2013 16:28:39 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Corey Minyard <cminyard@mvista.com>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RT 2/5] a few open coded completions
Message-ID: <20131215152839.GJ31090@linutronix.de>
References: <20131211003732.351606520@goodmis.org>
 <20131211003801.836995968@goodmis.org>
 <52A875D9.6090609@mvista.com>
 <20131211103420.291aa61c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131211103420.291aa61c@gandalf.local.home>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2013-12-11 10:34:20 [-0500]:

>As this chunck doesn't need to be in the stable branch, I'm just going
>to nuke it.
>
>I'll even fix up the change log too.

Thank you for the fixups. I just did the same thing in the v3.12 tree.
The chunk you nuked is now in Dave's net tree as a0a9663dd214 ("net: make
neigh_priv_len in struct net_device 16bit instead of 8bit"). As it
describes it is buggy on -RT but not mainline therefore it has no stable
tag for mainline and I would add one for RT.

>
>Thanks,
>
>-- Steve

Sebastian
