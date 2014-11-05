Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaKEJ1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:27:47 -0500
Received: from mail-bn1bbn0106.outbound.protection.outlook.com ([157.56.111.106]:20384
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751198AbaKEJ1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:27:45 -0500
Message-ID: <5459ED89.2080109@freescale.com>
Date: Wed, 5 Nov 2014 11:27:37 +0200
From: Cristian Stoica <cristian.stoica@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kim Phillips <kim.phillips@freescale.com>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <horia.geanta@freescale.com>, <marex@denx.de>
Subject: Re: [PATCH] crypto: caam: fix error reporting
References: <1414774653-3583-1-git-send-email-cristian.stoica@freescale.com>
	<20141031132209.5abced3ca9f55649d0bd6007@freescale.com>
	<5457486C.3030205@freescale.com>
	<20141103134716.775acd39d6334c6f8aeca151@freescale.com>
	<54589515.2010903@freescale.com>
 <20141104105731.ccb0eedea154b9bb6ed195b3@freescale.com>
In-Reply-To: <20141104105731.ccb0eedea154b9bb6ed195b3@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(24454002)(51704005)(479174003)(377454003)(6806004)(64706001)(19580395003)(46102003)(50466002)(36756003)(64126003)(87936001)(20776003)(62966003)(97736003)(69596002)(107046002)(104016003)(19580405001)(110136001)(87266999)(21056001)(83506001)(68736004)(65956001)(59896002)(44976005)(106466001)(31966008)(26826002)(80316001)(84676001)(23756003)(99396003)(81156004)(33656002)(4396001)(47776003)(92726001)(65806001)(54356999)(65816999)(76176999)(93886004)(105606002)(77156002)(120916001)(95666004)(50986999)(92566001)(102836001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB392;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB392;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0386B406AA
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=B18196@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

On 11/04/2014 06:57 PM, Kim Phillips wrote:
> On Tue, 4 Nov 2014 10:57:57 +0200
> Cristian Stoica <cristian.stoica@freescale.com> wrote:

>> Do you want me to drop the patch and pretend there is nothing to see?
> 
> no, fixing potential bugs preemptively is fine; I'd just like to
> know that's the case: it wasn't clear from the original commit
> message whether the problem occurred on a new h/w revision, in which
> case I'd have like to have seen the driver updated with support for
> the new error codes.

This is a preemptive fix. I did not see a problem in the field with any
hardware, recent or old.

Cristian S.
