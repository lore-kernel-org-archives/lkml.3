Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbaHDGVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 02:21:41 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:29449
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751053AbaHDGVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 02:21:39 -0400
Message-ID: <53DF2668.1010603@freescale.com>
Date: Mon, 4 Aug 2014 09:21:28 +0300
From: Cristian Stoica <cristian.stoica@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] crypto: add support for TLS 1.0 record encryption
References: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com>
 <1406626353-23309-2-git-send-email-cristian.stoica@freescale.com>
 <53DAA097.90005@amacapital.net> <53DB58A8.3070600@freescale.com>
 <CALCETrX3r2shBVTCR=WEmXNV+L=Qk7+ZxKYamWZ4EjVLgqU5kg@mail.gmail.com>
In-Reply-To: <CALCETrX3r2shBVTCR=WEmXNV+L=Qk7+ZxKYamWZ4EjVLgqU5kg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(189002)(24454002)(199002)(36756003)(26826002)(84676001)(50466002)(65816999)(47776003)(15975445006)(68736004)(92726001)(97736001)(83322001)(6806004)(81542001)(102836001)(54356999)(79102001)(92566001)(64126003)(80316001)(21056001)(44976005)(85852003)(76176999)(76482001)(83072002)(74662001)(110136001)(4396001)(99396002)(74502001)(33656002)(83506001)(87936001)(87266999)(93886004)(46102001)(86362001)(104016003)(59896001)(80022001)(105606002)(50986999)(65806001)(31966008)(107046002)(95666004)(19580395003)(81342001)(64706001)(23676002)(106466001)(65956001)(20776003)(77982001)(85306004);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB573;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0293D40691
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=cristian.stoica@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 01.08.2014 17:44, Andy Lutomirski wrote:
> If I understand it correctly, the issue is that cryptlen depends on
> the padding.  I added some notes inline above.  See here, too:
> 
> https://www.imperialviolet.org/2013/02/04/luckythirteen.html

Thanks for review. We'll address this issue and resend an updated patch.

Cristian S.
