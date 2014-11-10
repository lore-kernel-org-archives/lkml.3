Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaKJWml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:42:41 -0500
Received: from mail-bn1on0056.outbound.protection.outlook.com ([157.56.110.56]:30272
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751138AbaKJWmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:42:39 -0500
Date: Mon, 10 Nov 2014 14:42:31 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Peter Crosthwaite <crosthwaitepeter@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <michals@xilinx.com>, <sorenb@xilinx.com>,
        Steve Wang <steven.wang@digilentinc.com>
Subject: Re: [PATCH 2/2] arm: dts: zynq: Add Digilent ZYBO board
References: <1415504283-31321-1-git-send-email-crosthwaite.peter@gmail.com>
 <1415504283-31321-2-git-send-email-crosthwaite.peter@gmail.com>
 <548fd9c6edf94ca2b20299895f78b139@BN1AFFO11FD036.protection.gbl>
 <CAPokK=ovsR--ARj-2rNV6udbPEPqy4bChqC5FJw-u6O=cnHZQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPokK=ovsR--ARj-2rNV6udbPEPqy4bChqC5FJw-u6O=cnHZQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21090.003
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <a7677222807f4dd3a7d74df647e48598@BL2FFO11FD053.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(6009001)(438002)(51704005)(189002)(377424004)(199003)(377454003)(24454002)(102836001)(62966003)(77096003)(77156002)(4396001)(104016003)(93886004)(44976005)(108616004)(19580405001)(83506001)(19580395003)(64706001)(85182001)(87936001)(92566001)(20776003)(47776003)(53416004)(6806004)(50986999)(95666004)(21056001)(50466002)(1411001)(46102003)(99396003)(107046002)(54356999)(120916001)(31966008)(106466001)(76176999)(86362001)(74316001)(110136001)(23676002)(85202003)(107986001)(24736002)(23106004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB018;H:xsj-pvapsmtpgw01;FPR:;MLV:ovrnspm;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB018;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB018;
X-Forefront-PRVS: 039178EF4A
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB018;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 08:39AM +1000, Peter Crosthwaite wrote:
> On Mon, Nov 10, 2014 at 7:47 AM, Sören Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> > Hi Peter,
> >
> > On Sun, 2014-11-09 at 01:38PM +1000, Peter Crosthwaite wrote:
> >> Add a DTS describing the Digilent ZYBO board. Similar to ZED but with
> >
> > "Digilent ZYBO" here...
> >
> > [...]
> >> +/ {
> >> +     model = "Zynq ZYBO Development Board";
> >> +     compatible = "xlnx,zynq-zybo", "xlnx,zynq-7000";
> >
> > ... "xlnx,zynq-zybo" here. Seems inconsistent. IMHO, there should rather be
> > a digilent vendor prefix.
> >
> 
> Was going for consistency with ZED which also makes this mistake:
> 
>     model = "Zynq Zed Development Board";
>     compatible = "xlnx,zynq-zed", "xlnx,zynq-7000";
> 
> We have to choose between consistency and correctness. If we do fix it
> though, what is Diglent's four-letter vendor prefix?

Since Digilent is the board vendor, I'm for using the appropriate
prefix. Vendor prefixes are found in
Documentation/devicetree/bindings/vendor-prefixes.txt.

	Soren
