Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbaJaVDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:03:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:40426 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753606AbaJaVD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:03:29 -0400
Date: Fri, 31 Oct 2014 17:03:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>
Subject: [ANNOUNCE] 3.14.23-rt20
Message-ID: <20141031170326.1491a63f@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.14.23-rt20 stable release.

This is the first 3.14-rt release in the stable-rt series. Normally I
wait till the next development release is out before I pull in a new
one. That is, I would pull in 3.14-rt when 3.16-rt or later was
released. But because development is now moving at a "hobbyist rate" 
 (read http://lwn.net/Articles/617140/ for details)
and 3.14-rt is no longer being developed against, I figured it was time
to put it under the "stable-rt" umbrella.

This release is just an update to the new stable 3.14.23 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.14-rt
  Head SHA1: 98a86c73c8828ba724eafaef832d71e3c909fb73


Or to build 3.14.23-rt20 directly, the following patches should be
applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.14.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.14.23.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.14/patch-3.14.23-rt20.patch.xz




Enjoy,

-- Steve

