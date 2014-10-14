Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaJNItW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:49:22 -0400
Received: from mail-by2on0107.outbound.protection.outlook.com ([207.46.100.107]:28000
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754304AbaJNItC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:49:02 -0400
Message-ID: <543CE374.9080008@freescale.com>
Date: Tue, 14 Oct 2014 11:48:52 +0300
From: Cristian Stoica <cristian.stoica@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3.14 36/37] crypto: caam - fix addressing of struct member
References: <20141013022400.286360067@linuxfoundation.org>
 <20141013022401.796709337@linuxfoundation.org>
 <543CDF7C.4080209@freescale.com> <20141014083854.GB3141@kroah.com>
In-Reply-To: <20141014083854.GB3141@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(24454002)(164054003)(189002)(377454003)(479174003)(6806004)(64706001)(44976005)(65806001)(80316001)(65956001)(80022003)(84676001)(47776003)(68736004)(92566001)(64126003)(85306004)(23756003)(93886004)(20776003)(83506001)(87936001)(102836001)(33656002)(54356999)(26826002)(76176999)(65816999)(85852003)(87266999)(92726001)(46102003)(50986999)(31966008)(110136001)(105606002)(106466001)(76482002)(36756003)(95666004)(97736003)(50466002)(21056001)(59896002)(4396001)(104016003)(120916001)(99396003)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0634;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0634;
X-Forefront-PRVS: 03648EFF89
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B18196@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I mean whatever is currently stable, maintained and more recent than 3.13.

Thanks,
Cristian S.


On 10/14/2014 11:38 AM, Greg Kroah-Hartman wrote:
> On Tue, Oct 14, 2014 at 11:31:56AM +0300, Cristian Stoica wrote:
>> Hi Greg,
>>
>> You can cherry-pick 307fd543f3d23f8f56850eca1b27b1be2fe71017 on stable
>> 3.13+ as well. The original 'cc stable 3.13+' line was deleted by
>> mistake during commit.
> 
> 3.13-stable is long dead and not being maintained by me anymore, sorry.
> 
> greg k-h
> 
