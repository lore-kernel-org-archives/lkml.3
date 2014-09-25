Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaIYW4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 18:56:39 -0400
Received: from mail-bn1on0130.outbound.protection.outlook.com ([157.56.110.130]:52928
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751568AbaIYW4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 18:56:38 -0400
Message-ID: <1411685780.13320.209.camel@snotra.buserror.net>
Subject: Re: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
 CLK_OF_DECLARE support
From: Scott Wood <scottwood@freescale.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Lu Jingchang-B35083 <jingchang.lu@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 25 Sep 2014 17:56:20 -0500
In-Reply-To: <20140925225406.19023.25065@quantum>
References: <1411454806-8214-1-git-send-email-jingchang.lu@freescale.com>
	 <d4a375f40b544cf1ae78ac82dc20569c@BL2PR03MB467.namprd03.prod.outlook.com>
	 <1411675680.13320.201.camel@snotra.buserror.net>
	 <20140925225406.19023.25065@quantum>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:416f:c6f:49e6:9e61]
X-ClientProxiedBy: BN1PR08CA0050.namprd08.prod.outlook.com (10.242.217.178) To
 CY1PR0301MB0730.namprd03.prod.outlook.com (25.160.159.148)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0730;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(377424004)(24454002)(189002)(51704005)(64706001)(107046002)(104166001)(85852003)(81542003)(47776003)(76176999)(50986999)(4396001)(83322001)(77156001)(81342003)(88136002)(46102003)(106356001)(74662003)(74502003)(62966002)(83072002)(77982003)(20776003)(89996001)(21056001)(85306004)(90102001)(76482002)(92566001)(87286001)(80022003)(79102003)(110136001)(50466002)(86362001)(93886004)(87976001)(102836001)(31966008)(77096002)(42186005)(93916002)(10300001)(92726001)(50226001)(103116003)(95666004)(97736003)(101416001)(33646002)(23676002)(120916001)(99396003)(105586002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0730;H:[IPv6:2601:2:5800:3f7:416f:c6f:49e6:9e61];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0762;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-25 at 15:54 -0700, Mike Turquette wrote:
> Quoting Scott Wood (2014-09-25 13:08:00)
> > Well, like I said, I'd rather see the CLK_OF_DECLARE stuff be made to
> > work on PPC rather than have the driver carry around two binding
> > methods.
> 
> I guess that is an existing problem, and not related directly to this
> patch? This patch is essentially just renames (though the V1.0/V2.0
> stuff seems weird).

This patch is adding CLK_OF_DECLARE.

-Scott


