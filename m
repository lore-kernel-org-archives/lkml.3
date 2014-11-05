Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaKEQsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:48:53 -0500
Received: from mail-by2on0109.outbound.protection.outlook.com ([207.46.100.109]:22269
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751805AbaKEQsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:48:51 -0500
X-Greylist: delayed 161776 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2014 11:48:51 EST
Date: Wed, 5 Nov 2014 10:43:32 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Cristian Stoica <cristian.stoica@freescale.com>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <horia.geanta@freescale.com>, <marex@denx.de>
Subject: Re: [PATCH v2] crypto: caam: fix error reporting
Message-ID: <20141105104332.bdc904792193d714bd9d4951@freescale.com>
In-Reply-To: <1415179284-19791-1-git-send-email-cristian.stoica@freescale.com>
References: <20141104105731.ccb0eedea154b9bb6ed195b3@freescale.com>
	<1415179284-19791-1-git-send-email-cristian.stoica@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(164054003)(24454002)(189002)(199003)(51704005)(86362001)(44976005)(31966008)(93916002)(107046002)(87286001)(106466001)(76176999)(50986999)(23726002)(50466002)(100306002)(99396003)(102836001)(120916001)(46406003)(47776003)(64706001)(97736003)(68736004)(20776003)(19580405001)(19580395003)(104016003)(110136001)(15975445006)(6806004)(15202345003)(92566001)(21056001)(89996001)(105606002)(95666004)(33646002)(87936001)(88136002)(46102003)(36756003)(104166001)(4396001)(26826002)(84676001)(77156002)(62966003)(92726001)(50226001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0616;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0616;
X-Forefront-PRVS: 0386B406AA
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 11:21:24 +0200
Cristian Stoica <cristian.stoica@freescale.com> wrote:

> The error code returned by hardware is four bits wide with an expected
> zero MSB. A hardware error condition where the error code can get between
> 0x8 and 0xf will trigger an out of bound array access on the error
> message table.
> This patch fixes the invalid array access following such an error and
> reports the condition.
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
> ---

no v2 change info?  All I noticed is the additional string for
"queue manager interface", which, without its implementation fn,
intoduces an inconsistency wrt NULL checking, so this comment:

http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg12105.html

still applies.

Thanks,

Kim
