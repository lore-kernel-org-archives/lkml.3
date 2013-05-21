Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3EUDe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:34:59 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:48093 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab3EUDe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:34:58 -0400
Message-ID: <519AEB59.4040105@ozlabs.ru>
Date: Tue, 21 May 2013 13:34:49 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexey Kardashevskiy <aik@ozlabs.ru>
CC: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 v2] VFIO PPC64: add VFIO support on POWERPC64
References: <1369107191-28547-1-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1369107191-28547-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, wrong subject (cut-n-paste) :)
There are 3 patches, not 5.


On 05/21/2013 01:33 PM, Alexey Kardashevskiy wrote:
> The series adds support for VFIO on POWERPC in user space (such as QEMU).
> The in-kernel real mode IOMMU support is added by another series posted
> separately.
> 
> As the first and main aim of this series is the POWERNV platform support,
> the "Enable on POWERNV platform" patch goes first and introduces an API
> to be used by the VFIO IOMMU driver. The "Enable on pSeries platform" patch
> simply registers PHBs in the IOMMU subsystem and expects the API to be present,
> it enables VFIO support in fully emulated QEMU guests.
> 
> The main change is that this series was changed and tested against v3.10-rc1.
> It also contains some bugfixes which are mentioned (if any) in the patch messages.
> 
> Alexey Kardashevskiy (3):
>   powerpc/vfio: Enable on POWERNV platform
>   powerpc/vfio: Implement IOMMU driver for VFIO
>   powerpc/vfio: Enable on pSeries platform


-- 
Alexey
