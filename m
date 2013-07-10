Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab3GJUEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:04:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31583 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab3GJUEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:04:53 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=wMIDhRfJcN64NjHzGzkA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373486692.7458.66.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.4.52-rt67
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Wed, 10 Jul 2013 16:04:52 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.4.52-rt67 stable release.


This release is just an update to the new stable 3.4.52 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.4-rt
  Head SHA1: 4f731bb73406647d745639b50b9f48a9b7508c45


Or to build 3.4.52-rt67 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.52.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.52-rt67.patch.xz




Enjoy,

-- Steve



