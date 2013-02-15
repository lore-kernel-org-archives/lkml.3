Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935299Ab3BOCqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 21:46:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24028 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab3BOCqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 21:46:04 -0500
Date: Thu, 14 Feb 2013 21:45:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.8-rc7-tag-two
Message-ID: <20130215024556.GA10506@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull one more tag (or if you haven't pulled the earlier one,
then just pull this one instead).


 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.8-rc7-tag-two

This has two reverts for patches added in the v3.8 time-frame. They introduced
a regression with the older hypervisors (Xen 4.1) so lets take these patches
out.

 arch/x86/xen/enlighten.c | 77 +++++++++++++++---------------------------------
 arch/x86/xen/suspend.c   |  2 +-
 arch/x86/xen/xen-ops.h   |  2 +-
 3 files changed, 25 insertions(+), 56 deletions(-)

Konrad Rzeszutek Wilk (2):
      Revert "xen/PVonHVM: fix compile warning in init_hvm_pv_info"
      Revert "xen PVonHVM: use E820_Reserved area for shared_info"

