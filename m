Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbaFZP5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:57:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:34126 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757799AbaFZP5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:57:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,554,1400050800"; 
   d="scan'208";a="450356957"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qat-linux <qat-linux@intel.com>
Subject: RE: linux-next: Tree for Jun 26 (crypto/qat)
Thread-Topic: linux-next: Tree for Jun 26 (crypto/qat)
Thread-Index: AQHPkU/929qaYn45/kW31CdxyLpen5uD8toA//+XOXA=
Date: Thu, 26 Jun 2014 15:57:37 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A1846567CBF0@ORSMSX105.amr.corp.intel.com>
References: <20140626164130.4d01a3b2@canb.auug.org.au>
 <53AC366C.5030504@infradead.org> <53AC36B8.8000303@infradead.org>
In-Reply-To: <53AC36B8.8000303@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Randy Dunlap
> Sent: Thursday, June 26, 2014 8:05 AM
> To: Stephen Rothwell; linux-next@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; qat-linux
> Subject: Re: linux-next: Tree for Jun 26 (crypto/qat)
> 
> On 06/26/14 08:04, Randy Dunlap wrote:
> > On 06/25/14 23:41, Stephen Rothwell wrote:
> >> Hi all,
> >>
> >> The powerpc allyesconfig is again broken more than usual.
> >>
> >> Changes since 20140625:
> >>
> >
> > on x86_64:
> >
> >   CC      drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.o
> > ../drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c: In function
> 'adf_enable_error_correction':
> > ../drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c:166:3:
> error: implicit declaration of function '__raw_readl' [-Werror=implicit-
> function-declaration]
> > ../drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c:168:3:
> error: implicit declaration of function '__raw_writel' [-Werror=implicit-
> function-declaration]
> > cc1: some warnings being treated as errors
> > make[5]: ***
> [drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.o] Error 1
> >
> >
> >
> 
> Sorry, I missed another one:
> ../drivers/crypto/qat/qat_dh895xcc/adf_hw_arbiter.c:100:3: error: implicit
> declaration of function '__raw_writel' [-Werror=implicit-function-
> declaration]

Both of these have already been fixed with commit bce3cc61 (crypto: qat - Fix random
build warnings) in the cryptodev-2.6 tree.

