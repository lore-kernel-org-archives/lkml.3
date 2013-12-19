Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab3LSWrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:47:52 -0500
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:27461 "EHLO
	rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab3LSWrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:47:51 -0500
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Dec 2013 17:47:50 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgMFAE90s1KtJV2b/2dsb2JhbABZgws4VbkvgRUWdIIlAQEBAwEBAiRSBQsCAQgOCi4oCiUCBA4Fh3wIDcp5F45fMwIFgyOBEwEDlUeCT4pLh0mBbYE+gio
X-IronPort-AV: E=Sophos;i="4.95,515,1384300800"; 
   d="scan'208";a="292834034"
From: "Upinder Malhi (umalhi)" <umalhi@cisco.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        "<linux-next@vger.kernel.org>" <linux-next@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-rdma@vger.kernel.org>" <linux-rdma@vger.kernel.org>,
        "<roland@kernel.org>" <roland@kernel.org>,
        "<hal.rosenstock@gmail.com>" <hal.rosenstock@gmail.com>
Subject: Re: randconfig build error with next-20131211, in
 drivers/infiniband/hw/usnic/usnic_uiom.c
Thread-Topic: randconfig build error with next-20131211, in
 drivers/infiniband/hw/usnic/usnic_uiom.c
Thread-Index: AQHO9onEl4ZbtG4u20aNBC/Rsse8YJpcYeEAgAArqwA=
Date: Thu, 19 Dec 2013 22:38:23 +0000
Message-ID: <B13BFDDB-0C52-4A27-B47B-05F71CB696FC@cisco.com>
References: <CA+r1ZhhA1QDeNwvOb+Yn_eoQ9VPS2VmAkGZXt8HJRiagp-rvTg@mail.gmail.com>
 <52B350BC.8000903@infradead.org>
In-Reply-To: <52B350BC.8000903@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.155.161.43]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <55CA01CFE2F675498CC32E6AB632F62A@emea.cisco.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy,
	This - http://www.spinics.net/lists/linux-rdma/msg18126.html- has fix for this.  Once the patch goes into ib for-next tree, the problem will go away.

Upinder

On Dec 19, 2013, at 12:02 PM, Randy Dunlap <rdunlap@infradead.org> wrote:

> On 12/11/13 07:57, Jim Davis wrote:
>> Building with the attached random configuration file,
>> 
>> drivers/infiniband/hw/usnic/usnic_uiom.c: In function
>> ‘usnic_uiom_attach_dev_to_pd’:
>> drivers/infiniband/hw/usnic/usnic_uiom.c:505:2: error: implicit declaration of f
>> unction ‘iommu_domain_has_cap’ [-Werror=implicit-function-declaration]
>>  if (!iommu_domain_has_cap(pd->domain, IOMMU_CAP_CACHE_COHERENCY)) {
>>  ^
>> cc1: some warnings being treated as errors
>> make[3]: *** [drivers/infiniband/hw/usnic/usnic_uiom.o] Error 1
>> 
> 
> 
> This build error still happens in linux-next of 20131219.
> 
> -- 
> ~Randy

