Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbbAHRBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:01:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbbAHRBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:01:33 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 0/3] xen: correct several bugs in new p2m list setup
Date: Thu,  8 Jan 2015 18:01:27 +0100
Message-Id: <1420736490-15351-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the setup code of the linear mapped p2m list several bugs have
been found, especially for 32 bit dom0. These patches correct the
errors and make 32 bit dom0 bootable again.

Juergen Gross (3):
  xen: correct error for building p2m list on 32 bits
  xen: correct race in alloc_p2m_pmd()
  xen: use correct type for physical addresses

 arch/x86/xen/p2m.c   | 11 ++++-------
 arch/x86/xen/setup.c |  6 ++++--
 2 files changed, 8 insertions(+), 9 deletions(-)

-- 
2.1.2

