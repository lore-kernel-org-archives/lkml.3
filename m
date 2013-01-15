Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab3AOWXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:23:37 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24974 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab3AOWXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:23:35 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: konrad@kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH] fixes to ACPI subsystem which assumes cpuidle is always enabled.
Date: Tue, 15 Jan 2013 17:23:22 -0500
Message-Id: <1358288604-24620-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached are two patches to the ACPI subsystem and the cpuidle drivers.

The fixes are to deal with the case when cpuidle_disabled returns true
and we try to hotplug CPUs on/off. 

 drivers/acpi/processor_idle.c | 3 +++
 drivers/idle/intel_idle.c     | 3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

