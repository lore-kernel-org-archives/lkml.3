Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3FJQxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:53:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51857 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab3FJQx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:53:29 -0400
Date: Mon, 10 Jun 2013 12:53:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.10-rc5-tag
Message-ID: <20130610165320.GA6135@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.10-rc5-tag

which has two fixes for regressions that occured in v3.10. The signed
tag has more details so replicating it here:
<tag>
Bug-fixes for regressions:
 - xen/tmem stopped working after a certain combination of modprobe/swapon was used
 - cpu online/offlining would trigger WARN_ON.
</tag>

Thanks!

 arch/x86/xen/smp.c | 8 ++++++++
 drivers/xen/tmem.c | 4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

Konrad Rzeszutek Wilk (2):
      xen/smp: Fixup NOHZ per cpu data when onlining an offline CPU.
      xen/tmem: Don't over-write tmem_frontswap_poolid after tmem_frontswap_init set it.

