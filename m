Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaCJO3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:29:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:23401 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752884AbaCJO3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:29:32 -0400
Date: Mon, 10 Mar 2014 10:29:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH RT 2/5] a few open coded completions
Message-ID: <20140310102928.7b2a2cfa@gandalf.local.home>
In-Reply-To: <1394324841.2861.56.camel@deadeye.wl.decadent.org.uk>
References: <20131211003732.351606520@goodmis.org>
	<20131211003801.836995968@goodmis.org>
	<20131211144946.27d82a78@gandalf.local.home>
	<1394324841.2861.56.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Mar 2014 00:27:21 +0000
Ben Hutchings <ben@decadent.org.uk> wrote:

> On Wed, 2013-12-11 at 14:49 -0500, Steven Rostedt wrote:
> > Here's the new patch:
> 
> Doesn't add #includes and doesn't change any types, so of course it
> doesn't compile.  WTF?
> 

Hi Ben,

This is an old thread. Which kernel did you apply it to. Before I send
any patch set out, I run a small test (heavy stress test, and also
compile several different configs). This patch was against 3.10-rt, and
may have already had the includes needed. I know the original patch
compiled, but I may not have tested the second patch.

Do you need this patch? Or did I miss something for 3.2-rt?

-- Steve
