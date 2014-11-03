Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaKCQIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:08:09 -0500
Received: from mail-by2on0123.outbound.protection.outlook.com ([207.46.100.123]:14638
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751922AbaKCQIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:08:05 -0500
X-Greylist: delayed 890 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Nov 2014 11:08:05 EST
X-WSS-ID: 0NEH04K-07-84T-02
X-M-MSG: 
Message-ID: <5457A4E0.30109@amd.com>
Date: Mon, 3 Nov 2014 09:53:04 -0600
From: Tom Lendacky <thomas.lendacky@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Stephan Mueller <smueller@chronox.de>, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        "Jason Cooper" <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2 01/11] crypto: Documentation - crypto API high level
 spec
References: <6375771.bx7QqLJLuR@tachyon.chronox.de>
 <4163724.RCMDlx8dmE@tachyon.chronox.de> <20141103083439.635f5cb6@lwn.net>
 <4303532.NGaUQ44sQJ@tachyon.chronox.de>
 <20141103144925.GA31688@gondor.apana.org.au>
In-Reply-To: <20141103144925.GA31688@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(164054003)(189002)(24454002)(199003)(479174003)(377454003)(86362001)(110136001)(68736004)(50466002)(31966008)(93886004)(21056001)(92726001)(83506001)(92566001)(84676001)(101416001)(77156002)(99396003)(4396001)(97736003)(102836001)(33656002)(120916001)(87936001)(46102003)(54356999)(76176999)(64126003)(106466001)(64706001)(47776003)(65806001)(36756003)(44976005)(20776003)(65816999)(23746002)(107046002)(65956001)(50986999)(62966003)(95666004)(105586002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB203;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 08:49 AM, Herbert Xu wrote:
> On Mon, Nov 03, 2014 at 03:18:29PM +0100, Stephan Mueller wrote:
>>
>>>> + * CRYPTO_ALG_TYPE_DIGEST	Raw message digest
>>>> + * CRYPTO_ALG_TYPE_HASH		Alias for CRYPTO_ALG_TYPE_DIGEST
>>>> + * CRYPTO_ALG_TYPE_SHASH	Synchronous multi-block hash
>>>> + * CRYPTO_ALG_TYPE_AHASH	Asynchronous multi-block hash
>>>> + * CRYPTO_ALG_TYPE_RNG		Random Number Generation
>>>> + * CRYPTO_ALG_TYPE_PCOMPRESS
>>>
>>> What's that last one?
>>
>> Same here.
>
> pcompress is an enhanced version of compress allowing for piece-meal
> compression/decompression rather than having to shove everything in
> all at once.
>
> Eventually pcompress should replace the compress interface once
> everything is converted across.

Herbert, I was looking at adding async support for ALG_TYPE_COMPRESS
since the CCP device will support compression/decompression but only
as an everything at once invocation.  Given what you're saying about
pcompress replacing compress, would this be something you'd even
consider though?

Thanks,
Tom

>
> Thanks,
>
