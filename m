Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3EMQ5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:57:05 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:43770 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3EMQ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:57:04 -0400
X-IronPort-AV: E=Sophos;i="4.87,663,1363132800"; 
   d="scan'208";a="23713370"
Date: Mon, 13 May 2013 17:57:00 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [GIT PULL] (arm/xen) fixes-for-3.10-rc2-tag
Message-ID: <alpine.DEB.2.02.1305131648330.4799@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
please pull the following tag (based on my previous 3.9-rc3-smp-6-tag):

git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git  fixes-for-3.10-rc2-tag


It contains a couple of Xen on ARM initialization fixes and a patch to
improve error handling.



Stefano Stabellini (3):
      xen/arm: initialize pm functions later
      xen/arm: do not handle VCPUOP_register_vcpu_info failures
      xen/arm: rename xen_secondary_init and run it on every online cpu

 arch/arm/xen/enlighten.c |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)
