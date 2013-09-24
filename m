Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab3IXV2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:28:39 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:45791 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753991Ab3IXV2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:28:38 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Sep 2013 17:28:38 EDT
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        udknight@gmail.com, aik@ozlabs.ru, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH v4 0/2] iommu: Add iommu_error class event to iommu trace 
Date: Tue, 24 Sep 2013 15:21:18 -0600
Message-Id: <cover.1380056222.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds iommu_error class event to iommu trace. iommu_error class
event can be enabled to trigger when an iommu error occurs. This trace event
is intended to be called to report the error information. Trace information
includes driver name, device name, iova, and flags.

iommu_error:io_page_fault

This patch set depends on the previous patch set that added iommu tracing
feature. Reference:

http://www.kernelhub.org/?msg=313155&p=2
http://www.kernelhub.org/?msg=313156&p=2

Shuah Khan (2):
  iommu: Add iommu_error class event to iommu trace
  iommu: Change iommu driver to call io_page_fault trace event

 drivers/iommu/iommu-traces.c |  3 +++
 include/linux/iommu.h        |  2 ++
 include/trace/events/iommu.h | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

-- 
1.8.1.2

