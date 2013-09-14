Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab3INBiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 21:38:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15116 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095Ab3INBiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 21:38:11 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=ttXaytHqugIc9cpVeocA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 13 Sep 2013 21:38:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.6.11.9-rt42
Message-ID: <20130913213809.07ac1d58@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.6.11.9-rt42 stable release.


This release is just an update to the new stable 3.6.11.9 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.6-rt
  Head SHA1: a9ed5595c987a8e3166d84904eb111fe550b5ebd


Or to build 3.6.11.9-rt42 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.6.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.6.11.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/stable/patch-3.6.11.9.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.11.9-rt42.patch.xz




Enjoy,

-- Steve

