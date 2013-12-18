Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab3LRDwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 22:52:25 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:31674 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751936Ab3LRDwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 22:52:24 -0500
Date: Tue, 17 Dec 2013 22:52:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.10.24-rt22
Message-ID: <20131217225219.23b50f68@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.10.24-rt22 stable release.


This release is just an update to the new stable 3.10.24 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.10-rt
  Head SHA1: e88b1c51941d964e77ef7e9099075ae2e8dafd75


Or to build 3.10.24-rt22 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.10.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.10.24.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patch-3.10.24-rt22.patch.xz




Enjoy,

-- Steve

