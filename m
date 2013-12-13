Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab3LMCuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:50:14 -0500
Received: from tundra.namei.org ([65.99.196.166]:34725 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab3LMCuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:50:12 -0500
Date: Fri, 13 Dec 2013 13:52:09 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] SELinux fixes
Message-ID: <alpine.LRH.2.02.1312131351140.31472@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull.


The following changes since commit 54fb723cc48db2fde964fb9bb0eaaccf2cf31a9f:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2013-12-12 15:46:06 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Geyslan G. Bem (1):
      selinux: fix possible memory leak

James Morris (1):
      Merge branch 'master' of git://git.infradead.org/users/pcmoore/selinux_fixes into for-linus

Paul Moore (5):
      Merge tag 'v3.12'
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_postroute()
      selinux: look for IPsec labels on both inbound and outbound packets
      selinux: process labeled IPsec TCP SYN-ACK packets properly in selinux_ip_postroute()

 security/selinux/hooks.c        |  137 ++++++++++++++++++++++++++++++++-------
 security/selinux/include/xfrm.h |    8 ++-
 security/selinux/xfrm.c         |   62 ++++++++++++++----
 3 files changed, 165 insertions(+), 42 deletions(-)
