Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbaEPA1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 20:27:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50849 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaEPA1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 20:27:41 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-66-53755b7b3e77
From: Jingoo Han <jg1.han@samsung.com>
To: "'Murali Karicheri'" <m-karicheri2@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com>
 <1400169692-9677-2-git-send-email-m-karicheri2@ti.com>
In-reply-to: <1400169692-9677-2-git-send-email-m-karicheri2@ti.com>
Subject: Re: [PATCH v1 1/5] ARM: keystone: add pcie related options
Date: Fri, 16 May 2014 09:27:38 +0900
Message-id: <004e01cf709d$a48b4240$eda1c6c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9wV22VEP7cn5uSRMOaZ+kpTceLowARZZCA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zQ93q6NJgg+7tPBaXF15itdj0+Bqr
	xeVdc9gszs47zmZx+zKvRV/vATaL131rmB3YPVqae9g8Ni+p9+jbsorR4/iN7UwenzfJBbBG
	cdmkpOZklqUW6dslcGXMap7OVHCRq+Lbl89MDYw3OLoYOTgkBEwkll6x6mLkBDLFJC7cW88G
	YgsJLGOU2Hg1BSJuInH03D6mLkYuoPh0RomeHxtZIZzfjBJfn95hBqliE1CT+PLlMDuILSKg
	I7HseCNYB7PAE0aJNSefskOMrZb4OO87mM0p4Cxx58NGRhBbGMjevnoKC4jNIqAqcerVfzaQ
	63gFbCVmHKwCCfMKCEr8mHwPrIRZQEti/c7jTBC2vMTmNW+ZIZ5Rl3j0VxfiBCOJk033mSFK
	RCT2vXjHCHKOhMBbdomHM3+xQqwSkPg2+RALRK+sxKYDzBAPS0ocXHGDZQKjxCwkm2ch2TwL
	yeZZSFYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRESt707GG8fsD7EmAy0fiKzlGhy
	PjDu80riDY3NjCxMTUyNjcwtzUgTVhLnTXqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	UYrzWo+cRJrjBymjpv/5TTcDr37nmC24kS3u99dZxeF2vwO48t8zH7Dzcb1l0SarN/3u0Qt9
	UwJUPPvst/9ID+0WUxb8JZ0Y+5fD1PWkVe2/FWcVZXOCDA9Kvzh8192zmK3ugs4i7wez92yJ
	s9tR8Kl6ZZrd1LTkNW9Cd7H8PTT/rejeb6mzlFiKMxINtZiLihMBcj2xxPECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQd3q6NJgg5kNHBaXF15itdj0+Bqr
	xeVdc9gszs47zmZx+zKvRV/vATaL131rmB3YPVqae9g8Ni+p9+jbsorR4/iN7UwenzfJBbBG
	NTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBdoaRQ
	lphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMmNU8nangIlfFty+fmRoYb3B0
	MXJySAiYSBw9t48JwhaTuHBvPVsXIxeHkMB0RomeHxtZIZzfjBJfn95hBqliE1CT+PLlMDuI
	LSKgI7HseCMTSBGzwBNGiTUnn4IlhASqJT7O+w5mcwo4S9z5sJERxBYGsrevnsICYrMIqEqc
	evUfaB0HB6+ArcSMg1UgYV4BQYkfk++BlTALaEms33mcCcKWl9i85i0zSLmEgLrEo7+6ECcY
	SZxsus8MUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9d
	Lzk/dxMjODE8k97BuKrB4hCjAAejEg/vBa3SYCHWxLLiytxDjBIczEoivKdtgUK8KYmVValF
	+fFFpTmpxYcYk4H+nMgsJZqcD0xaeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1O
	TS1ILYLZwsTBKdXAuO2OoM5xr2qZBsm8uEuf2k55pgTXzdUP1ZWQYV6av+mu8uwJrTd+za35
	aegZPceW51LZ8tfBf+SmbX3wMF0nMkW+gr096cStVuEffWvu/WZorWBl/j0htVhwXmOlhX/m
	ygmr0623B96vP2qy6dnOhSd+h/V+y1/TmiB2Ilrs/KkT642kpx8wUWIpzkg01GIuKk4EAAop
	kQxQAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 16, 2014 1:01 AM, Murali Karicheri wrote:
> 
> Add pcie related options by default for keystone architecture
> 
> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> CC: Russell King <linux@arm.linux.org.uk>
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  arch/arm/mach-keystone/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/mach-keystone/Kconfig b/arch/arm/mach-keystone/Kconfig
> index f50bc93..f87844d 100644
> --- a/arch/arm/mach-keystone/Kconfig
> +++ b/arch/arm/mach-keystone/Kconfig
> @@ -8,6 +8,8 @@ config ARCH_KEYSTONE
>  	select COMMON_CLK_KEYSTONE
>  	select ARCH_SUPPORTS_BIG_ENDIAN
>  	select ZONE_DMA if ARM_LPAE
> +	select MIGHT_HAVE_PCI
> +	select ARCH_SUPPORTS_MSI

Please, don't select ARCH_SUPPORTS_MSI, because this kconfig
option was already removed in v3.12 by the commit ebd97be635
('PCI: remove ARCH_SUPPORTS_MSI kconfig option'). So. there is
NO need to select 'ARCH_SUPPORTS_MSI'.

Best regards,
Jingoo Han

>  	help
>  	  Support for boards based on the Texas Instruments Keystone family of
>  	  SoCs.
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

