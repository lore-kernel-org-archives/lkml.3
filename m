Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaHAIZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:25:07 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:26971
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754085AbaHAIY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:24:59 -0400
Message-ID: <53DB4EC3.3080507@freescale.com>
Date: Fri, 1 Aug 2014 11:24:35 +0300
From: Cristian Stoica <cristian.stoica@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Add TLS record layer encryption module
References: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com>
 <53DAA031.30405@amacapital.net>
In-Reply-To: <53DAA031.30405@amacapital.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(51704005)(97736001)(21056001)(23756003)(50986999)(54356999)(86362001)(102836001)(80316001)(79102001)(85852003)(104016003)(65816999)(76176999)(33656002)(26826002)(85306004)(74662001)(31966008)(92726001)(84676001)(4396001)(81542001)(81156004)(69596002)(81342001)(83506001)(99396002)(76482001)(92566001)(36756003)(107046002)(83072002)(87936001)(44976005)(6806004)(77982001)(106466001)(74502001)(64706001)(65956001)(2201001)(50466002)(64126003)(87266999)(47776003)(83322001)(95666004)(80022001)(20776003)(105606002)(68736004)(65806001)(59896001)(46102001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB562;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029097202E
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=cristian.stoica@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This set of patches introduces support for TLS 1.0 record layer
>> encryption/decryption with a corresponding algorithm called
>> tls10(hmac(<hash>),cbc(<cipher>)).
>>
>> Similarly to authenc.c on which it is based, this module mixes the base
>> algorithms in software to produce an algorithm that does record layer
>> encryption and decryption for TLS1.0.
>> Any combination of hw and sw base algorithms is possible, but the purpose
>> is to take advantage of hardware acceleration for TLS record layer offloading
>> when hardware acceleration is present.
> 
> What is this used for?  AF_ALG?  I find it hard to believe that the
> kernel will ever want to use this internally.

Yes, AF_ALG is what we have in mind.

Cristian S.
