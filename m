Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab3HPRUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:20:43 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:48218 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755028Ab3HPRUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:20:37 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        udknight@gmail.com, aik@ozlabs.ru, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH 0/2] iommu: Add iommu_fault class event to iommu trace
Date: Fri, 16 Aug 2013 11:20:15 -0600
Message-Id: <cover.1376672275.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds iommu_fault class event to iommu trace. iommu_fault class
event can be enabled to trigger when an iommu fault occurs. This trace event
is intended to be called to report the fault information. Trace information
includes driver name, device name, iova, and flags.

iommu_fault:report_fault

This patch set depends on the previous patch set that added iommu tracing
feature. Reference:

http://www.kernelhub.org/?msg=313155&p=2
http://www.kernelhub.org/?msg=313156&p=2

Shuah Khan (2):
  iommu: Add iommu_fault class event to iommu trace
  iommu: Change iommu driver to call report_fault trace event

 drivers/iommu/iommu-traces.c |    3 +++
 include/linux/iommu.h        |    2 ++
 include/trace/events/iommu.h |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

-- 
1.7.10.4

