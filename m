Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab3GLLDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:03:07 -0400
Received: from cdw.me.uk ([91.203.57.136]:57075 "EHLO cdw.me.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932525Ab3GLLDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:03:05 -0400
Date: Fri, 12 Jul 2013 12:03:02 +0100
From: Chris Webb <chris@arachsys.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Simple tool using user namespaces to build containers
Message-ID: <20130712110301.GA10675@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prompted by the merge of support for user namespaces in recent kernels, I've
written a couple of simple standalone tools that use them together with
mount, PID and other namespaces to implement containers.

I've put these utilities up here in case they're of use to anyone else, and
also as demonstrations of how easy-to-use these new kernel interfaces are:

  https://github.com/arachsys/containers
  http://arachsys.github.io/downloads/containers-0.9.tar.gz
  http://arachsys.github.io/downloads/containers-0.9.tar.sign

They support the same /etc/subuid and /etc/subgid files that Eric Biederman
proposed in his patch set against the shadow package, which will hopefully
become a fairly standard mechanism for delegating extra users and groups.

User namespaces arrived without much fanfare, but they're really useful new
functionality. I was pleasantly surprised how straightforward it was to
build both fully isolated containers, and also a replacement for fakeroot
which allows me to chroot to build packages.

Many thanks to Eric for working on this and also for patiently explaining
the rationale behind the design decision to remap user IDs on the kernel
list recently.

Cheers,

Chris.
