Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097AbaHMGyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 02:54:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:4136 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbaHMGyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 02:54:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,855,1400050800"; 
   d="scan'208";a="575969926"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: bhelgaas@google.com, rdunlap@infradead.org
Cc: bp@alien8.de, tony.luck@intel.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND 0/5] PCIe, AER: Misc cleanup
Date: Wed, 13 Aug 2014 02:22:36 -0400
Message-Id: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No response since last commit so spread it to a bigger range.

This patch series is for AER related cleanup & update based on PCIe
SPEC r3.0.
