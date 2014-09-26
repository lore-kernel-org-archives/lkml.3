Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbaIZUG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:06:26 -0400
Received: from mail-bl2on0089.outbound.protection.outlook.com ([65.55.169.89]:55002
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755431AbaIZUGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:06:25 -0400
Date: Fri, 26 Sep 2014 13:06:20 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: David Miller <davem@davemloft.net>
CC: <nicolas.ferre@atmel.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] Revert "net/macb: add pinctrl consumer support"
References: <1411429748-31444-1-git-send-email-soren.brinkmann@xilinx.com>
 <20140926.154930.1459165439870528648.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140926.154930.1459165439870528648.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20976.005
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <b3c8ab73-4dd5-436e-9647-c4a43e40c3a9@BL2FFO11FD051.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(43544003)(377424004)(24454002)(199003)(189002)(51704005)(90102001)(23676002)(85306004)(95666004)(77096002)(70736001)(64706001)(53416004)(104016003)(1496007)(106466001)(47776003)(20776003)(107046002)(110136001)(76482002)(85182001)(87936001)(50466002)(4396001)(6806004)(44976005)(83322001)(19580395003)(19580405001)(102836001)(81342003)(83072002)(85852003)(92566001)(86362001)(21056001)(99396003)(10300001)(74316001)(120916001)(31696002)(85202003)(54356999)(92726001)(31966008)(76176999)(46102003)(77982003)(74662003)(81542003)(79102003)(50986999)(83506001)(80022003)(74502003)(107986001)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB006;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 03:49PM -0400, David Miller wrote:
> From: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Date: Mon, 22 Sep 2014 16:49:08 -0700
> 
> > This reverts commit 8ef29f8aae524bd51298fb10ac6a5ce6c4c5a3d8.
> > The driver core already calls pinctrl_get() and claims the default
> > state. There is no need to replicate this in the driver.
> > ---
> > Hi,
> > 
> > I might be mistaken, but I think the driver core does already take care of
> > calling into the pinctrl framework and the driver does not need to do it on its
> > own (drivers/base/dd.c:really_probe() calls 'pinctrl_bind_pins() which takes
> > care of the pinctrl setup).
> > 
> 
> Applied and queued up for -stable, thanks.

thx

> Next time please provide a proper "Signed-off-by: " in the commit message
> of your submission.

Yeah, sorry for that. I overlooked that one. My alias for commit takes
care of this, but I don't have that for revert.

In case you need it:
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

	Sören
