Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaBTIY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:24:57 -0500
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:25979
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752550AbaBTIY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:24:56 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH Resend] regmap: fix _regmap_update_bits()
Thread-Topic: [PATCH Resend] regmap: fix _regmap_update_bits()
Thread-Index: AQHPLd7q0Z2vByHzw0eCmMQ8D1Ny5pq9btuAgABfDMA=
Date: Thu, 20 Feb 2014 08:24:53 +0000
Message-ID: <618b45af88a3496f900fc8b6d53abf2f@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1392857410-9068-1-git-send-email-Li.Xiubo@freescale.com>
 <20140220024147.GT2669@sirena.org.uk>
In-Reply-To: <20140220024147.GT2669@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.215]
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(199002)(189002)(24454002)(95416001)(46102001)(81542001)(81342001)(54316002)(54356001)(56776001)(76482001)(53806001)(80976001)(69226001)(94946001)(93136001)(51856001)(93516002)(95666001)(86362001)(94316002)(33646001)(47976001)(49866001)(59766001)(50986001)(92566001)(47736001)(83322001)(74876001)(65816001)(66066001)(4396001)(85306002)(56816005)(74502001)(47446002)(90146001)(31966008)(74662001)(85852003)(81686001)(81816001)(63696002)(87936001)(74366001)(2656002)(80022001)(83072002)(79102001)(77982001)(87266001)(74316001)(76576001)(74706001)(76786001)(76796001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:192.88.158.215;FPR:EE12C056.A5325791.B8F315F0.C4E1E2F5.20136;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH Resend] regmap: fix _regmap_update_bits()
> 
> On Thu, Feb 20, 2014 at 08:50:10AM +0800, Xiubo Li wrote:
> 
> > This resend version just rewrites the commit comment.
> 
> I've applied this but I updated the commit log further - part of the
> reason this didn't get applied first time around was that it says it's a
> fix but it's actually a coding style change.

Yes, it's.

Thanks very much for your updating.

--
Best Regards,
Xiubo

> The other part of the
> reason was that at first glance I wasn't sure if it was actually an
> improvement so wanted to think about it.
