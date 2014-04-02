Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbaDBDNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 23:13:40 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:23752
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752523AbaDBDNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 23:13:39 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux@roeck-us.net" <linux@roeck-us.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] regmap: mmio: Fix the bug of 'offset' value parsing.
Thread-Topic: [PATCH] regmap: mmio: Fix the bug of 'offset' value parsing.
Thread-Index: AQHPTLEaoyg26X4ysUSgJy7g1wpY45r8tSYAgADzxGA=
Date: Wed, 2 Apr 2014 03:13:36 +0000
Message-ID: <d203bcf4b50945e6bb02cfa7740c528e@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1396247611-22289-1-git-send-email-Li.Xiubo@freescale.com>
 <20140401123822.GW2269@sirena.org.uk>
In-Reply-To: <20140401123822.GW2269@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(51704005)(24454002)(74316001)(76786001)(65816001)(54316002)(56776001)(76796001)(76576001)(99286001)(54356001)(74366001)(33646001)(98676001)(63696002)(79102001)(66066001)(80022001)(99396002)(77982001)(59766001)(47736001)(31966008)(74662001)(4396001)(49866001)(47976001)(81342001)(47446002)(20776003)(69226001)(81542001)(53806001)(50986001)(74876001)(74502001)(86362001)(85852003)(93136001)(83322001)(93516002)(83072002)(81686001)(19580395003)(51856001)(80976001)(85306002)(74706001)(92566001)(76482001)(46102001)(87936001)(97336001)(97186001)(94316002)(95666003)(95416001)(94946001)(2656002)(56816005)(87266001)(90146001)(81816001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:BCDCFBE5.2CA2CC19.33F517BF.8CA9D859.2020B;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH] regmap: mmio: Fix the bug of 'offset' value parsing.
> 
> On Mon, Mar 31, 2014 at 02:33:31PM +0800, Xiubo Li wrote:
> > 'offset = *(u32 *)reg;', this will be okey for 32/64-bit register, but
> > for 8/16-bit register, the 'offset' value will overflow.
> 
> This doesn't apply against regmap-v3.15, please check and resend.
> 
> > The core trace:
> > ===============
> > Unable to handle kernel paging request at virtual address ffbd0000
> > pgd = 871e8000
> > [ffbd0000] *pgd=00000000
> > Internal error: Oops: 805 [#1] ARM
> > Modules linked in:
> > CPU: 0 PID: 1004 Comm: sh Not tainted 3.14.0-rc6+ #990
> > task: 871baa40 ti: 87090000 task.ti: 87090000
> 
> Don't paste entire backtraces into commit messages, they're enormous and
> most of the detail isn't useful making it easy to miss relevant
> information - either pick relevant sections or just describe the
> failure.

Yes, I have resent this patch and have fixed the issue that you pointed out.

Thanks :)
--

Best Regards,
Xiubo
