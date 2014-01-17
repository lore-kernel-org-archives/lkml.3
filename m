Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaAQEWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 23:22:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:57085 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751298AbaAQEWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 23:22:32 -0500
Date: Thu, 16 Jan 2014 23:22:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RT 4/8] rtmutex: use a trylock for waiter lock in
 trylock
Message-ID: <20140116232228.0f3cfb89@gandalf.local.home>
In-Reply-To: <1389841737.5418.14.camel@marge.simpson.net>
References: <20140116015824.201732155@goodmis.org>
	<20140116020324.637491369@goodmis.org>
	<1389841737.5418.14.camel@marge.simpson.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014 04:08:57 +0100
Mike Galbraith <bitbucket@online.de> wrote:

> On Wed, 2014-01-15 at 20:58 -0500, Steven Rostedt wrote:
> 
> 
> > 3.2.53-rt76-rc1 stable review patch.
> > If anyone has any objections, please let me know.
> 
> Not sure this is needed without the tglx don't unconditionally raise
> timer softirq patch, and with that patch applied in the form it exists
> in 3.12-rt9, as well as this one, you'll still eventually deadlock.

Hmm, I'll have to take a look. This sounds to be missing from all the
stable -rt kernels. I'll be pulling in the latest updates from 3.12-rt
soon.

Thanks,

-- Steve

