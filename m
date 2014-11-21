Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbaKUJgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:36:00 -0500
Received: from mail-bn1bn0108.outbound.protection.outlook.com ([157.56.110.108]:53664
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757935AbaKUJf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:35:56 -0500
From: Tang Yuantian <Yuantian.Tang@freescale.com>
To: <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>, <r64188@freescale.com>,
        Tang Yuantian <Yuantian.Tang@freescale.com>
Subject: [PATCH v2 2/2] cpufreq: qoriq: rename the driver
Date: Fri, 21 Nov 2014 17:18:38 +0800
Message-ID: <1416561518-24835-2-git-send-email-Yuantian.Tang@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1416561518-24835-1-git-send-email-Yuantian.Tang@freescale.com>
References: <1416561518-24835-1-git-send-email-Yuantian.Tang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(19580395003)(92726001)(64706001)(87286001)(84676001)(20776003)(47776003)(88136002)(68736004)(4396001)(104016003)(50226001)(92566001)(87936001)(93916002)(102836001)(6806004)(44976005)(86362001)(99396003)(89996001)(48376002)(31966008)(76176999)(50466002)(120916001)(21056001)(106466001)(95666004)(105606002)(107046002)(229853001)(50986999)(104166001)(19580405001)(36756003)(46102003)(97736003)(77156002)(62966003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1291;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1291;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1291;
X-Forefront-PRVS: 0402872DA1
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Yuantian.Tang@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1291;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver works on all QorIQ platforms which include
ARM-based cores and PPC-based cores.
Rename it in order to represent better.

Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
---
v2:
	- use -C -M options when format-patch

 drivers/cpufreq/{ppc-corenet-cpufreq.c => qoriq-cpufreq.c} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename drivers/cpufreq/{ppc-corenet-cpufreq.c => qoriq-cpufreq.c} (100%)

diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/qoriq-cpufreq.c
similarity index 100%
rename from drivers/cpufreq/ppc-corenet-cpufreq.c
rename to drivers/cpufreq/qoriq-cpufreq.c
-- 
2.1.0.27.g96db324

