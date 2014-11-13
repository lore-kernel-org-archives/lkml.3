Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147AbaKMVLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:11:13 -0500
Received: from mail-bn1on0132.outbound.protection.outlook.com ([157.56.110.132]:56622
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933636AbaKMVLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:11:12 -0500
X-WSS-ID: 0NEZXIG-07-T2T-02
X-M-MSG: 
Message-ID: <54651E61.8030500@amd.com>
Date: Thu, 13 Nov 2014 23:10:57 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: HSA RT is now Open Source
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(15975445006)(59896002)(83506001)(46102003)(64706001)(92726001)(15202345003)(47776003)(86362001)(20776003)(92566001)(99136001)(101416001)(84676001)(80316001)(64126003)(4396001)(50466002)(44976005)(68736004)(23676002)(19580395003)(102836001)(31966008)(65806001)(65956001)(33656002)(65816999)(107046002)(105586002)(36756003)(54356999)(87266999)(77156002)(87936001)(62966003)(50986999)(95666004)(120916001)(106466001)(21056001)(97736003)(229853001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Forefront-PRVS: 0394259C80
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm pleased to announce that AMD has published the full code of the HSA
Runtime library.

The code can be found at:
https://github.com/HSAFoundation/HSA-Runtime-Reference-Source

As I stated in the amdkfd v5 cover letter, this release, coupled with the r600
LLVM back-end, provides a complete userspace Open Source stack/solution for
running HSA applications using kernels written in OpenCL C99 on top of amdkfd.

As promised, the git repository also contains an HSA port of the OpenCL
MatrixMultiplication application, which can be used to demonstrate how the
compiler, stack, libhsakmt and, of course, amdkfd work together. Together with
the c file of the application, we have provided the source of the OpenCL kernel
and a binary version of that kernel.

There are complete instructions in the git repo on how to build the HSA RT and
the HSA application from source. In addition, if someone wishes to compile the
OpenCL kernel, there are instructions on how to do it (using the modified r600
LLVM).

If anyone is interested in running the sample HSA application on Kaveri H/W,
please take my latest amdkfd-v6 branch and together with the updated Kaveri
firmware files.

The amdkfd-v6 branch can be found at:
http://cgit.freedesktop.org/~gabbayo/linux/?h=amdkfd-v6

The firmware can be found at :
http://people.freedesktop.org/~gabbayo/firmware/ucode.tar.gz

Finally, I would like to thank the HSA RT team, the Finalizer team, the Open
Source graphics team and last but not least, John Bridgman, for helping with
this release.

	-Oded
