Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaKIVr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 16:47:57 -0500
Received: from mail-bn1on0055.outbound.protection.outlook.com ([157.56.110.55]:44480
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751350AbaKIVr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 16:47:56 -0500
Date: Sun, 9 Nov 2014 13:47:51 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Peter Crosthwaite <crosthwaitepeter@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <michals@xilinx.com>, <sorenb@xilinx.com>,
        <steven.wang@digilentinc.com>
Subject: Re: [PATCH 2/2] arm: dts: zynq: Add Digilent ZYBO board
References: <1415504283-31321-1-git-send-email-crosthwaite.peter@gmail.com>
 <1415504283-31321-2-git-send-email-crosthwaite.peter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1415504283-31321-2-git-send-email-crosthwaite.peter@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21088.002
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <548fd9c6edf94ca2b20299895f78b139@BN1AFFO11FD036.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(377424004)(24454002)(199003)(120916001)(53416004)(83506001)(95666004)(6806004)(46102003)(77156002)(21056001)(62966003)(86362001)(102836001)(77096003)(4396001)(92566001)(74316001)(44976005)(23676002)(54356999)(64706001)(20776003)(31966008)(47776003)(76176999)(50986999)(110136001)(104016003)(87936001)(85182001)(99396003)(50466002)(108616004)(106466001)(33646002)(1411001)(107046002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB055;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB055;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB055;
X-Forefront-PRVS: 0390DB4BDA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB055;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Sun, 2014-11-09 at 01:38PM +1000, Peter Crosthwaite wrote:
> Add a DTS describing the Digilent ZYBO board. Similar to ZED but with

"Digilent ZYBO" here...

[...]
> +/ {
> +	model = "Zynq ZYBO Development Board";
> +	compatible = "xlnx,zynq-zybo", "xlnx,zynq-7000";

... "xlnx,zynq-zybo" here. Seems inconsistent. IMHO, there should rather be
a digilent vendor prefix.

Everything else looks pretty straight forward and good.

	Soren
