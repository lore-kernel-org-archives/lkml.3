Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab3LRDD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 22:03:26 -0500
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:4283
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752573Ab3LRDDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 22:03:25 -0500
Message-ID: <1387335782.3140.11.camel@snotra.buserror.net>
Subject: Re: [v3][PATCH 1/8] powerpc/book3e: rename interrupt_end_book3e
 with __end_interrupts
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 17 Dec 2013 21:03:02 -0600
In-Reply-To: <1373357007-30785-2-git-send-email-tiejun.chen@windriver.com>
References: <1373357007-30785-1-git-send-email-tiejun.chen@windriver.com>
	 <1373357007-30785-2-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BLUPR04CA001.namprd04.prod.outlook.com (10.255.219.149)
 To DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 0064B3273C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(51704005)(189002)(199002)(377424004)(24454002)(19580395003)(80976001)(56816005)(23676002)(53806001)(90146001)(42186004)(51856001)(89996001)(85306002)(76482001)(49866001)(65816001)(79102001)(63696002)(47776003)(19580405001)(50986001)(81816001)(47736001)(4396001)(83322001)(47976001)(81686001)(69226001)(46102001)(87976001)(59766001)(88136002)(85852003)(77096001)(87266001)(77982001)(54316002)(87286001)(74366001)(56776001)(76786001)(83072002)(80022001)(81542001)(31966008)(74502001)(74662001)(47446002)(81342001)(74706001)(50226001)(50466002)(76796001)(77156001)(74876001)(33646001)(62966002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-09 at 16:03 +0800, Tiejun Chen wrote:
> We can rename 'interrupt_end_book3e' with '__end_interrupts' then
> book3s/book3e can share this unique label to make sure we can use
> this conveniently.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>

What users of this do you plan to share between book3s and book3e?  I'm
not seeing any existing book3s users that are obviously applicable to
book3e -- they mainly involve copying exception vectors which we
shouldn't need to do.

-Scott


