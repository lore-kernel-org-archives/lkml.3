Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab3LSUCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:02:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35741 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3LSUCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:02:09 -0500
Message-ID: <52B350BC.8000903@infradead.org>
Date: Thu, 19 Dec 2013 12:02:04 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, umalhi@cisco.com, roland@kernel.org,
        hal.rosenstock@gmail.com
Subject: Re: randconfig build error with next-20131211, in drivers/infiniband/hw/usnic/usnic_uiom.c
References: <CA+r1ZhhA1QDeNwvOb+Yn_eoQ9VPS2VmAkGZXt8HJRiagp-rvTg@mail.gmail.com>
In-Reply-To: <CA+r1ZhhA1QDeNwvOb+Yn_eoQ9VPS2VmAkGZXt8HJRiagp-rvTg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13 07:57, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/infiniband/hw/usnic/usnic_uiom.c: In function
> ‘usnic_uiom_attach_dev_to_pd’:
> drivers/infiniband/hw/usnic/usnic_uiom.c:505:2: error: implicit declaration of f
> unction ‘iommu_domain_has_cap’ [-Werror=implicit-function-declaration]
>   if (!iommu_domain_has_cap(pd->domain, IOMMU_CAP_CACHE_COHERENCY)) {
>   ^
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/infiniband/hw/usnic/usnic_uiom.o] Error 1
> 


This build error still happens in linux-next of 20131219.

-- 
~Randy
