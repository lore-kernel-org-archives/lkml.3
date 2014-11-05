Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaKEFFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 00:05:18 -0500
Received: from mail-by2on0110.outbound.protection.outlook.com ([207.46.100.110]:39360
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750908AbaKEFFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 00:05:14 -0500
X-WSS-ID: 0NEJVGH-08-I1U-02
X-M-MSG: 
Date: Wed, 5 Nov 2014 12:39:51 +0800
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Tony Li <tony.li@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: remove warning of disable scramble check
Message-ID: <20141105043951.GA9906@hr-slim.amd.com>
References: <1415093391-4569-1-git-send-email-ray.huang@amd.com>
 <20141104144726.GD24983@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141104144726.GD24983@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(24454002)(51704005)(164054003)(189002)(46102003)(101416001)(68736004)(120916001)(4396001)(95666004)(106466001)(97736003)(53416004)(33656002)(110136001)(77096003)(62966003)(77156002)(64706001)(50466002)(23726002)(83506001)(102836001)(86362001)(107046002)(105586002)(20776003)(92566001)(50986999)(97756001)(46406003)(84676001)(44976005)(54356999)(21056001)(47776003)(92726001)(76176999)(99396003)(31966008)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0386B406AA
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 08:47:26AM -0600, Felipe Balbi wrote:
> On Tue, Nov 04, 2014 at 05:29:51PM +0800, Huang Rui wrote:
> > Some SoC's FPGA platform will need this quirk, but it will complain if
> > running at true SoC platform. This is a normal case, so remove this
> > warning.
> 
> nope, why do you need disable_scramble on actual SoC ? Without an
> erratum number I will not accept this, sorry.
> 

Oh, that's my faulty. I can set disable_scramble_quirk=false after
actual SoC, at that time, we can drop FPGA support. :)

Thanks,
Rui
