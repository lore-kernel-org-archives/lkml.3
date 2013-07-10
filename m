Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab3GJUE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:04:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27273 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab3GJUE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:04:27 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=ABX-P0hQ1aq62ihpuswA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373486665.7458.65.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.6.11.6-rt38
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Wed, 10 Jul 2013 16:04:25 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.6.11.6-rt38 stable release.


This release is just an update to the new stable 3.6.11.6 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.6-rt
  Head SHA1: 9291036c51de8c84d0796e3d61e648aa1319f95e


Or to build 3.6.11.6-rt38 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.6.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.6.11.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/stable/patch-3.6.11.6.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.11.6-rt38.patch.xz




Enjoy,

-- Steve



