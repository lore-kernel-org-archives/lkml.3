Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935084AbaLLPb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:31:59 -0500
Received: from mail-bn1on0085.outbound.protection.outlook.com ([157.56.110.85]:36531
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934991AbaLLPb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:31:57 -0500
Date: Fri, 12 Dec 2014 09:31:57 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: kbuild test robot <fengguang.wu@intel.com>, <kbuild-all@01.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH socfpga-nex] staging: fpga manager: socfpga_fpga_ops can
 be static
In-Reply-To: <20141211204030.42c33e71@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.02.1412120931340.29302@linuxheads99>
References: <201412110903.GCuPHwdi%fengguang.wu@intel.com> <20141211014324.GA73956@lkp-sb04> <20141211204030.42c33e71@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR00CA0011.namprd00.prod.outlook.com (25.160.102.21) To
 BN3PR0301MB1235.namprd03.prod.outlook.com (25.161.207.23)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1235;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601003);SRVR:BN3PR0301MB1235;
X-Forefront-PRVS: 04238CD941
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(24454002)(189002)(199003)(107046002)(46406003)(33716001)(105586002)(81156004)(106356001)(77156002)(97736003)(110136001)(4396001)(50466002)(21056001)(68736005)(122386002)(62966003)(46102003)(101416001)(31966008)(23726002)(19580395003)(19580405001)(20776003)(76176999)(42186005)(69596002)(99396003)(87976001)(83506001)(50986999)(66066001)(86362001)(47776003)(53416004)(120916001)(64706001)(92566001)(86152002)(54356999);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1235;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1235;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014, One Thousand Gnomes wrote:

> On Thu, 11 Dec 2014 09:43:24 +0800
> kbuild test robot <fengguang.wu@intel.com> wrote:
> 
> > drivers/staging/fpga/socfpga.c:655:25: sparse: symbol 'socfpga_fpga_ops' was not declared. Should it be static?
> > 
> > Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> 
> Ought to be const as well by the look of it - we don't want function
> pointers in patchable memory spaces.
> 

I agree.  Will be in v5.

Alan
