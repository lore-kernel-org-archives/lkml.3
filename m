Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbbATEVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 23:21:38 -0500
Received: from smtprelay0080.hostedemail.com ([216.40.44.80]:43673 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751235AbbATEVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 23:21:37 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:967:969:973:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1539:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2565:2682:2685:2687:2859:2895:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3690:3770:3865:3867:3868:3871:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6261:6684:7266:7875:8509:8599:8985:9025:9072:9121:9388:10004:10049:10400:10848:11232:11233:11658:11914:12043:12266:12438:12517:12519:12555:12663:12679:13018:13019:13069:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: toy82_652dda7da7933
X-Filterd-Recvd-Size: 1541
Date: Mon, 19 Jan 2015 23:21:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.14.29-rt26
Message-ID: <20150119232132.704772de@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.14.29-rt26 stable release.


This release is just an update to the new stable 3.14.29 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.14-rt
  Head SHA1: 3af4a72c71387c38fe88def573dbb80837927862


Or to build 3.14.29-rt26 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.14.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.14.29.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.14/patch-3.14.29-rt26.patch.xz




Enjoy,

-- Steve

