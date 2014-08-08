Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbaHHJXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:23:15 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:58628
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756399AbaHHJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:23:11 -0400
Message-ID: <53E496E4.9070207@freescale.com>
Date: Fri, 8 Aug 2014 12:22:44 +0300
From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Cristian Stoica <cristian.stoica@freescale.com>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: testmgr.c: white space fix-ups on test_aead
References: <1406542283-11995-1-git-send-email-cristian.stoica@freescale.com>
In-Reply-To: <1406542283-11995-1-git-send-email-cristian.stoica@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(164054003)(51704005)(24454002)(479174003)(377454003)(199002)(189002)(74662001)(95666004)(31966008)(74502001)(64706001)(81342001)(81542001)(50986999)(84676001)(26826002)(97736001)(47776003)(83072002)(20776003)(76482001)(85852003)(64126003)(107046002)(4396001)(80022001)(65806001)(65956001)(54356999)(92566001)(92726001)(50466002)(86362001)(6806004)(80316001)(44976005)(83322001)(19580395003)(19580405001)(21056001)(46102001)(68736004)(102836001)(106466001)(79102001)(83506001)(33656002)(65816999)(87266999)(76176999)(69596002)(105606002)(110136001)(85182001)(59896001)(36756003)(99396002)(87936001)(77982001)(23676002)(104016003)(85306004)(81156004);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0610;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Horia.Geanta@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/2014 1:11 PM, Cristian Stoica wrote:
> This patch inverts two if conditions and allows removal of one
> tab-stop in their code-blocks. Only white-space clean-up follows.
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
> ---
>  crypto/testmgr.c | 498 +++++++++++++++++++++++++++----------------------------
>  1 file changed, 242 insertions(+), 256 deletions(-)

This increases readability and reduces number of lines, not to mention
cyclomatic complexity.

While here, could you do this also for other places, like __test_hash?

Thanks,
Horia


