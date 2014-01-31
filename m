Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbaAaVpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:45:09 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:48294 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaAaVpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:45:03 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org, sasha.levin@oracle.com,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 0/2] tools: lockdep: build fixes
Date: Fri, 31 Jan 2014 13:35:30 -0800
Message-Id: <1391204132-14071-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.8.3.2
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (ovro.ovro.caltech.edu [0.0.0.0]); Fri, 31 Jan 2014 13:35:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ira W. Snyder" <iws@ovro.caltech.edu>

Included are some fixes to the tools/lib/lockdep source tree to fix some
build issues.

Ira W. Snyder (2):
  tools: lockdep: fix include of asm/hash.h
  tools: lockdep: add include directory to allow tests to compile

 tools/lib/lockdep/Makefile            | 2 +-
 tools/lib/lockdep/uinclude/asm/hash.h | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)
 create mode 100644 tools/lib/lockdep/uinclude/asm/hash.h

-- 
1.8.3.2

