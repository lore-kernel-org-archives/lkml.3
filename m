Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaKLP6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:58:13 -0500
Received: from mail-bn1on0088.outbound.protection.outlook.com ([157.56.110.88]:62168
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752377AbaKLP6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:58:11 -0500
Date: Wed, 12 Nov 2014 07:57:58 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Vinod Koul <vinod.koul@intel.com>, <dmaengine@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] Documentation: devicetree: Fix Xilinx VDMA
 specification
References: <1415800277-6817-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415800277-6817-1-git-send-email-afaerber@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21096.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <6067bede14b9421fa87db96bdc66dc66@BN1AFFO11FD040.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(199003)(189002)(377424004)(86362001)(50466002)(108616004)(62966003)(99396003)(102836001)(87936001)(74316001)(120916001)(85182001)(44976005)(77096003)(46102003)(77156002)(31966008)(4396001)(110136001)(83506001)(33646002)(6806004)(95666004)(53416004)(92566001)(47776003)(21056001)(20776003)(76176999)(50986999)(54356999)(64706001)(85202003)(23676002)(107046002)(104016003)(106466001)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB021;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB021;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB021;
X-Forefront-PRVS: 03932714EB
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB021;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 02:51PM +0100, Andreas Färber wrote:
> The specification requires xlnx,data-width, but example and driver use
> xlnx,datawidth. Change the specification to match the implementation.

Isn't this the wrong way around? The bindings are considered API, so
shouldn't the driver be fixed to match the spec?
Are there already dts files out there using either of these options?

	Soren
