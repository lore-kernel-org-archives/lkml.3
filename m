Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaHKGeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 02:34:06 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:43002
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751511AbaHKGeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 02:34:04 -0400
Message-ID: <53E863CE.3060509@freescale.com>
Date: Mon, 11 Aug 2014 09:33:50 +0300
From: Cristian Stoica <cristian.stoica@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>,
        <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>
Subject: Re: [PATCH 2/3] crypto: testmgr.c: white space removal on __test_skcipher
References: <53E496E4.9070207@freescale.com>
 <1407497272-9161-1-git-send-email-cristian.stoica@freescale.com>
 <1407497272-9161-2-git-send-email-cristian.stoica@freescale.com>
 <53E733EF.80003@freescale.com>
In-Reply-To: <53E733EF.80003@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(189002)(199002)(24454002)(51404002)(377454003)(479174003)(102836001)(33656002)(107046002)(85852003)(83072002)(92566001)(92726001)(64126003)(87936001)(86362001)(26826002)(4396001)(31966008)(74662001)(95666004)(76176999)(74502001)(99396002)(65816999)(105606002)(106466001)(50986999)(54356999)(21056001)(87266999)(81156004)(104016003)(84676001)(69596002)(68736004)(47776003)(80316001)(44976005)(83322001)(6806004)(36756003)(79102001)(77982001)(83506001)(80022001)(59896001)(65806001)(65956001)(85306004)(64706001)(20776003)(93886004)(46102001)(81342001)(97736001)(50466002)(23676002)(76482001)(81542001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB389;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03008837BD
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=cristian.stoica@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Horia,

On 10.08.2014 11:57, Horia Geantă wrote:
> On 8/8/2014 2:27 PM, Cristian Stoica wrote:
> Don't add more checkpatch warnings on top of existing ones.

I've weighted all the checkpatch warnings and errors introduced by these
patches and I've found them fair versus Linux coding style guide.

If these are the only barriers to acceptance then I'll consider an
update if Herbert agrees with the patches:

> WARNING: line over 80 characters
> #58: FILE: crypto/testmgr.c:992:
> 
>> +			crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);

This line is 82 chars long. I find it slightly more readable than the
alternative[s].

"The limit on the length of lines is 80 columns and this is a strongly
preferred limit [...] unless exceeding 80 columns significantly
increases readability and does not hide information"

Now this is a debate about "slightly" vs "significantly". Have fun.

Cristian S.
