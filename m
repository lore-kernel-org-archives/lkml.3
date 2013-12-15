Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3LOVId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 16:08:33 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:17828 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750821Ab3LOVIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 16:08:32 -0500
Date: Sun, 15 Dec 2013 16:08:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Corey Minyard <cminyard@mvista.com>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RT 2/5] a few open coded completions
Message-ID: <20131215160825.196fcc1e@gandalf.local.home>
In-Reply-To: <20131215152839.GJ31090@linutronix.de>
References: <20131211003732.351606520@goodmis.org>
	<20131211003801.836995968@goodmis.org>
	<52A875D9.6090609@mvista.com>
	<20131211103420.291aa61c@gandalf.local.home>
	<20131215152839.GJ31090@linutronix.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Dec 2013 16:28:39 +0100
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:


> Thank you for the fixups. I just did the same thing in the v3.12 tree.
> The chunk you nuked is now in Dave's net tree as a0a9663dd214 ("net: make
> neigh_priv_len in struct net_device 16bit instead of 8bit"). As it
> describes it is buggy on -RT but not mainline therefore it has no stable
> tag for mainline and I would add one for RT.

Yeah, I realized that too. I'll be adding it to the stable release.
That's why I didn't do the releases on Friday. I'll do them on Monday
after one final test with re-adding that change.

Thanks!

-- Steve
