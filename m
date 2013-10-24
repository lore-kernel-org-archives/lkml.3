Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3JXPyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:54:01 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:41729 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755899Ab3JXPx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:53:59 -0400
Message-ID: <1382630031.5283.26.camel@pippen.local.home>
Subject: [ANNOUNCE] 3.8.13.9-rt20
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Thu, 24 Oct 2013 11:53:51 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.8.13.9-rt20 stable release.


This release is just an update to the new stable 3.8.13.9 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.8-rt
  Head SHA1: 492b96082c7baa1f750239d431a2ca38a5c4d5e5
492b96082c7baa1f750239d431a2ca38a5c4d5e5


Or to build 3.8.13.9-rt20 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.8.13.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/stable/patch-3.8.13.9.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13.9-rt20.patch.xz




Enjoy,

-- Steve



