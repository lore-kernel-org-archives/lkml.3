Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaJ2Ddp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:33:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:11619 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbaJ2Ddn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:33:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="407617893"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 0/2] ACPI/EC: Fix regressions on Samsung hardware.
Date: Wed, 29 Oct 2014 11:33:33 +0800
Message-Id: <cover.1414553399.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <544CE637.7000406@odi.ch>
References: <544CE637.7000406@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is reported that the Samsung EC firmware behaves differently than Acer
EC firmware. And then previous 2 commits that fix Acer issues have broken
Samsung hardware.

This patchset fixes the regressions.

Lv Zheng (2):
  Revert "ACPI / EC: Add support to disallow QR_EC to be issued before
    completing previous QR_EC"
  ACPI/EC: Fix a regression caused by conflict firmware behavior
    between Samsung and Acer.

 drivers/acpi/ec.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

-- 
1.7.10

