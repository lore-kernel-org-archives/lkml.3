Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab3JXP6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:58:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:58713 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756150Ab3JXP55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:57:57 -0400
Message-ID: <1382630272.5283.31.camel@pippen.local.home>
Subject: [ANNOUNCE] 3.4.67-rt83
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Thu, 24 Oct 2013 11:57:52 -0400
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

I'm pleased to announce the 3.4.67-rt83 stable release.


This release is just an update to the new stable 3.4.67 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.4-rt
  Head SHA1: 22d48e16f6a4b433261f57639d141e414f95ae7a
22d48e16f6a4b433261f57639d141e414f95ae7a


Or to build 3.4.67-rt83 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.67.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.67-rt83.patch.xz




Enjoy,

-- Steve



