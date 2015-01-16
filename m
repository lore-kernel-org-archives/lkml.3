Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbbAPAou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 19:44:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:57784 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbbAPAos convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 19:44:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="441160135"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Purdila, Octavian" <octavian.purdila@intel.com>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Box, David E" <david.e.box@intel.com>,
        "Moore, Robert" <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>
Subject: About 2 ACPICA table patches
Thread-Topic: About 2 ACPICA table patches
Thread-Index: AdAxInxpvXNapHmAS86BpsqdPFELKA==
Date: Fri, 16 Jan 2015 00:44:38 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026B7CAD@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Octavian

I noticed there are 2 patches you've sent to the community.
But unfortunately I didn't find them in my mailbox.
Let me comment you here.

https://patchwork.kernel.org/patch/5501621/
This patch seem to be correct.
But Rafael should merge it directly via Linux because acpi_unload_table_id() is not in the ACPICA upstream.
We expect the OSPMs to use acpi_unload_parent_table() instead.
I have a divergences reduction series to achieve the transition.
But they are pending for review for almost half a year.
If you have an environment to test.
Could you help to test this again?
I can prepare the patchset for you.

https://patchwork.kernel.org/patch/5501561/
This patch is correct, I've put it in the 201501 ACPICA release materials for review:
https://patchwork.kernel.org/patch/5501621/
The patch can be found at:
https://github.com/zetalog/acpica/commit/281ff873
So if it is merged, you'll see it in the upstream after 201501 ACPICA release cycle.
And hence Linux trees doesn't need to merge this patch directly.

Thanks and best regards
-Lv
