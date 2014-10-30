Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934838AbaJ3WHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 18:07:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:51159 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934506AbaJ3WHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 18:07:02 -0400
Date: Thu, 30 Oct 2014 18:07:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.4.104-rt128
Message-ID: <20141030180700.71714cc6@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.4.104-rt128 stable release.


This release is just an update to the new stable 3.4.104 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.4-rt
  Head SHA1: b7ad894f6542777ee2a5358a0ceba0ca93d33c9c


Or to build 3.4.104-rt128 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.104.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.104-rt128.patch.xz




Enjoy,

-- Steve

