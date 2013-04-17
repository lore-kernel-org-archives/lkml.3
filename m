Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936287Ab3DQC3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 22:29:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:37982 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936221Ab3DQC3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 22:29:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,488,1363158000"; 
   d="scan'208";a="296003600"
From: "Jin, Yao" <yao.jin@intel.com>
To: "lwn@lwn.net" <lwn@lwn.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>
Subject: NumaTOP 1.0 launched
Thread-Topic: NumaTOP 1.0 launched
Thread-Index: Ac47E2RO2dru6Ae+Qfux+tcLBj5/ug==
Date: Wed, 17 Apr 2013 02:29:31 +0000
Message-ID: <0C6A3B2997299B4EAD81D386F36CD8C20FD915B0@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
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

We are pleased to announce today that the NumaTOP project has been added to 01.org. 

Performance analysis engineers know that NUMA can seriously impact performance and that NUMA performance analysis can be challenging. We've realized that currently there isn't an easy-to-use tool that lets us easily observe whether NUMA-related issues exist and, if so, where the NUMA bottleneck(s) reside. It can be quite challenging, especially in complex server environments. 

We decided to create a tool that automatically performs the typical steps in NUMA analysis and provides a good starting point to dive in and fix NUMA-related bottlenecks. That's NumaTOP!

NumaTOP is an observation tool for runtime memory locality characterization and analysis of processes and threads running on a NUMA system. It helps the user characterize the NUMA behavior of processes and threads and identify where the NUMA-related performance bottlenecks reside. It uses Intel performance counter sampling technologies and associates the performance data with system runtime information to provide real-time analysis for production systems.

NumaTOP is a GUI tool. It can run on Linux kernel 3.8 with a perf load latency patch today. That patch is planned to be integrated into kernel 3.9 or a later release.

To learn more about NumaTOP, visit:
http://01.org/numatop/

Best Regards
Jin Yao

