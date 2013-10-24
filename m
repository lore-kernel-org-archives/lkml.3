Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab3JXP7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:59:04 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:52985 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756184Ab3JXP67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:58:59 -0400
Message-ID: <1382630335.5283.32.camel@pippen.local.home>
Subject: [ANNOUNCE] 3.0.101-rt130
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Thu, 24 Oct 2013 11:58:55 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.0.101-rt130 stable release.


This release is just an update to the new stable 3.0.101 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.0-rt
  Head SHA1: b44cda4ab2532938924f1df4ebc876fd746b84d5
b44cda4ab2532938924f1df4ebc876fd746b84d5


Or to build 3.0.101-rt130 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.101.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.101-rt130.patch.xz




Enjoy,

-- Steve



