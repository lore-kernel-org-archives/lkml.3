Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbbAMEEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 23:04:06 -0500
Received: from mail-bn1bon0146.outbound.protection.outlook.com ([157.56.111.146]:50443
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750989AbbAMEEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 23:04:05 -0500
X-Greylist: delayed 937 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2015 23:04:04 EST
Date: Tue, 13 Jan 2015 11:55:53 +0800
From: Robin Gong <b38343@freescale.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <andriy.shevchenko@linux.jf.intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/3] dma: imx-sdma: reorg code to make code clean
Message-ID: <20150113035552.GB8251@Robin-OptiPlex-780>
References: <1414030940-15516-1-git-send-email-b38343@freescale.com>
 <1414030940-15516-4-git-send-email-b38343@freescale.com>
 <20141205164144.GP3411@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141205164144.GP3411@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(24454002)(51704005)(62966003)(6806004)(558084003)(33656002)(106466001)(23726002)(104016003)(105606002)(2950100001)(97756001)(77156002)(110136001)(54356999)(97736003)(76176999)(85426001)(77096005)(50466002)(64706001)(87936001)(33716001)(68736005)(47776003)(83506001)(50986999)(46406003)(46102003)(92566002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0630;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR0301MB0630;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0630;
X-Forefront-PRVS: 045584D28C
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0630;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2015 03:48:23.4095
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0630
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 10:11:44PM +0530, Vinod Koul wrote:
> On Thu, Oct 23, 2014 at 10:22:20AM +0800, Robin Gong wrote:
> > Code reorg for transfer prepare and bus width check to make code
> > cleaner.
> This should have been 1st patch :(
> 
> -- 
> ~Vinod
>
Got it.Thanks.
