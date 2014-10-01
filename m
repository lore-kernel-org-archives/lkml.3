Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbaJASAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:00:48 -0400
Received: from mail-bl2on0094.outbound.protection.outlook.com ([65.55.169.94]:60457
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751236AbaJASAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:00:46 -0400
Date: Wed, 1 Oct 2014 10:46:16 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Chris Kohn <ckohn@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michal Simek <michal.simek@xilinx.com>, Jason Wu <huanyu@xilinx.com>
Subject: Re: [PATCH] staging: Add Xilinx Clocking Wizard driver
References: <1412184108-16688-1-git-send-email-soren.brinkmann@xilinx.com>
 <20141001173957.GA32021@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141001173957.GA32021@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20984.005
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <e6907682-8d66-4df0-9a9e-a1079933e358@BL2FFO11FD008.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(377424004)(199003)(189002)(24454002)(77096002)(50986999)(85182001)(76176999)(102836001)(85306004)(1496007)(120916001)(10300001)(76482002)(6806004)(46102003)(80022003)(86362001)(31696002)(92726001)(87936001)(53416004)(83506001)(85852003)(92566001)(31966008)(44976005)(21056001)(50466002)(85202003)(95666004)(110136001)(104016003)(107046002)(20776003)(23676002)(54356999)(106466001)(64706001)(99396003)(4396001)(74316001)(47776003)(70736001)(107986001)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB041;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0351D213B3
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 10:39AM -0700, Greg Kroah-Hartman wrote:
> On Wed, Oct 01, 2014 at 10:21:48AM -0700, Soren Brinkmann wrote:
> > Add a driver for the Xilinx Clocking Wizard soft IP. The clocking wizard
> > provides an AXI interface to dynamically reconfigure the clocking
> > resources of Xilinx FPGAs.
> 
> Why not just do the few things you have on the TODO list and get it
> merged to the "proper" part of the kernel, keeping it out of the staging
> tree?

The few things are not that easy and as I mention in the TODO file,
there are some patches on LKML that would greatly simplify this
driver/reduce the need for code duplication.
I thought this is a good way to wait for those parts to mature while
people could already use the driver as passive part in their clock tree.

	Sören
