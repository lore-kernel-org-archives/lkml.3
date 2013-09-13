Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3IMQVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 12:21:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23292 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3IMQVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 12:21:39 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=fxJcL_dCAAAA:8 a=bUgllCsc1JuioeWpErMA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 13 Sep 2013 12:21:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [ANNOUNCE] 3.8.13.7-rt18
Message-ID: <20130913122137.63d5c2bc@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.8.13.7-rt18 stable release.

Note, the 3.8-rt stable series will now be using the Ubuntu's
stable kernels as they are doing the work to backport stable changes
to 3.8.13. To keep things in one place, I have added a new directory:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/stable/

That will host the stable patches used to create the 3.8-rt tree.
The patches in that directory are created from the linux-3.8.y branch
in the Ubuntu git tree located here:

   git://kernel.ubuntu.com/ubuntu/linux.git

Special thanks goes to the Ubuntu kernel team for doing the work
that I am selfishly building -rt on top of.


This release is just an update to the new stable 3.8.13.7 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.8-rt
  Head SHA1: ea8e6ff212a50e9aa666de36df051b0d9bd8fe3e


Or to build 3.8.13.7-rt18 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.8.13.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/stable/patch-3.8.13.7.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13.7-rt18.patch.xz




Enjoy,

-- Steve

