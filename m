Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab3LRDqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 22:46:11 -0500
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:51635
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752514Ab3LRDqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 22:46:10 -0500
Message-ID: <1387338359.3140.40.camel@snotra.buserror.net>
Subject: Re: [v3][PATCH 6/8] book3e/kexec/kdump: implement ppc64 kexec
 specfic
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 17 Dec 2013 21:45:59 -0600
In-Reply-To: <1373357007-30785-7-git-send-email-tiejun.chen@windriver.com>
References: <1373357007-30785-1-git-send-email-tiejun.chen@windriver.com>
	 <1373357007-30785-7-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BLUPR08CA018.namprd08.prod.outlook.com (10.141.30.38) To
 DM2PR03MB399.namprd03.prod.outlook.com (10.141.84.148)
X-Forefront-PRVS: 0064B3273C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(199002)(51704005)(24454002)(377424004)(189002)(76796001)(80976001)(65816001)(76786001)(80022001)(83322001)(19580405001)(74706001)(79102001)(81686001)(54316002)(81342001)(62966002)(19580395003)(23676002)(87286001)(56776001)(87976001)(74366001)(47776003)(77982001)(90146001)(63696002)(89996001)(69226001)(50466002)(81542001)(50986001)(47736001)(56816005)(47976001)(49866001)(4396001)(50226001)(88136002)(31966008)(74662001)(47446002)(74502001)(51856001)(46102001)(83072002)(85852003)(77096001)(77156001)(74876001)(87266001)(76482001)(85306002)(558084003)(59766001)(42186004)(53806001)(33646001)(81816001)(32563001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB399;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-09 at 16:03 +0800, Tiejun Chen wrote:
> ppc64 kexec mechanism has a different implementation with ppc32.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>

Could you describe the relevant differences?

-Scott


