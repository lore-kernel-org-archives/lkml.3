Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965174Ab3BNRjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:39:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4302 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798Ab3BNRjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:39:35 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=sdRxHD9KAAAA:8 a=-cgCmhteL8iAP9IdmqoA:9 a=PUjeQqilurYA:10 a=O0cec7rUORkA:10 a=2-my-mrWqlIbjv3T:21 a=O24ADgbSc8ydOXJy:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360863573.23152.47.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.0.63-rt89
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 14 Feb 2013 12:39:33 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.0.63-rt89 stable release.


This release is just an update to the new stable 3.0.63 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 65d2b279b50daefbece2c9b5fdd90eee9f0be503


Or to build 3.0.63-rt89 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.63.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.63-rt89.patch.xz



Enjoy,

-- Steve



