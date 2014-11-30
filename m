Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaK3SM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 13:12:56 -0500
Received: from mail-by2on0098.outbound.protection.outlook.com ([207.46.100.98]:3592
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752332AbaK3SMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 13:12:55 -0500
Date: Sun, 30 Nov 2014 10:12:51 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Anjana Sasindran <anjanasasindran123@gmail.com>
CC: <gregkh@linuxfoundation.org>, <laurent.pinchart@ideasonboard.com>,
        <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>
Subject: Re: [PATCH]
  staging:drivers:staging:clocking-wizard:clk-xlnx-clock-wizard.c: Added a
 line after declaration
References: <1417265730-5489-1-git-send-email-anjanasasindran123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417265730-5489-1-git-send-email-anjanasasindran123@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21142.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <a456fb93916548609f2636ab6d11aaa2@BL2FFO11FD022.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(189002)(164054003)(51704005)(377424004)(24454002)(23676002)(74316001)(86362001)(1411001)(19580395003)(83506001)(19580405001)(44976005)(107046002)(64706001)(104016003)(31966008)(50986999)(87936001)(6806004)(230783001)(47776003)(20776003)(53416004)(54356999)(21056001)(77156002)(110136001)(108616004)(85202003)(50466002)(106466001)(62966003)(76176999)(92566001)(99396003)(102836001)(46102003)(95666004)(85182001)(4396001)(120916001)(77096004)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB045;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB045;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB045;
X-Forefront-PRVS: 04111BAC64
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB045;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-11-29 at 06:25PM +0530, Anjana Sasindran wrote:
> This patch fix the checkpatch.pl warning
> 
> WARNING:Missing a blank line after declaration

There are two such warnings. If we gonna fix them, please fix them all.

> 
> Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
Acked-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

	Thanks,
	Sören
