Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935919AbaH0VnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:43:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:63868 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935548AbaH0VnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:43:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,414,1406617200"; 
   d="scan'208";a="594222535"
From: "David E. Box" <david.e.box@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: [PATCH 0/2] x86: iosf: change Kconfig selection and add debugfs
Date: Wed, 27 Aug 2014 14:40:38 -0700
Message-Id: <1409175640-32426-1-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a flaw with the iosf driver buidling as 'default m' on all x86 systems.
Adds debugfs support.

David E. Box (2):
  x86: iosf: Add Kconfig prompt for IOSF_MBI selection
  x86: iosf: Add debugfs support

 arch/x86/Kconfig           | 14 +++++++--
 arch/x86/kernel/iosf_mbi.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 2 deletions(-)

-- 
1.9.1

