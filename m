Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761661AbbA1God (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:44:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbbA1Gob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:44:31 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 0/5] xen: various cleanups
Date: Wed, 28 Jan 2015 07:44:20 +0100
Message-Id: <1422427465-25239-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several cleanups in xen kernel files:
- move declarations to header file
- delete not needed lines
- annotate functions as __init
- make functions static
- use correct types for addresses

No functional changes.

Juergen Gross (5):
  xen: cleanup arch/x86/xen/setup.c
  xen: use correct types for addresses in arch/x86/xen/setup.c
  xen: add some __init and static annotations in arch/x86/xen/setup.c
  xen: add some __init annotations in arch/x86/xen/mmu.c
  xen: cleanup arch/x86/xen/mmu.c

 arch/x86/xen/mmu.c     | 17 ++++++++---------
 arch/x86/xen/setup.c   | 37 ++++++++++++++-----------------------
 arch/x86/xen/xen-ops.h |  6 ++++++
 3 files changed, 28 insertions(+), 32 deletions(-)

-- 
2.1.2

