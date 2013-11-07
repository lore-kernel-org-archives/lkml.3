Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab3KGNzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:55:24 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:48316 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab3KGNzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:55:21 -0500
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vineet.Gupta1@synopsys.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: [PATCH v3 0/2] ARC: Add perf support for ARC700 cores
Date: Thu,  7 Nov 2013 14:55:10 +0100
Message-Id: <1383832512-21130-1-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please find v3 of my attempt to add support for perf for ARC700 PMU's. If
possible, it would be nice to get some feedback on the implementation from
non-ARC/Synopsys people familiar with the perf subsystem in Linux.

Thanks,

Mischa


v3:
	split devicetree binding doc into separate patch
	updated devicetree binding doc according to review comments
v2:
	updated comments to kernel coding standards
	renamed devicetree binding to snps,arc700-pmu
	added devicetree binding doc


Mischa Jonker (2):
  ARC: Add perf support for ARC700 cores
  ARC: Add documentation on DT binding for ARC700 PMU

 Documentation/devicetree/bindings/arc/pmu.txt |   24 ++
 arch/arc/boot/dts/angel4.dts                  |    4 +
 arch/arc/include/asm/perf_event.h             |  204 +++++++++++++++-
 arch/arc/kernel/Makefile                      |    1 +
 arch/arc/kernel/perf_event.c                  |  322 +++++++++++++++++++++++++
 5 files changed, 554 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/arc/pmu.txt
 create mode 100644 arch/arc/kernel/perf_event.c

-- 
1.7.9.5

