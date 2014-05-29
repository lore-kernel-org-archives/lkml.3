Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965026AbaE2GtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:49:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34274 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933694AbaE2Gs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:48:59 -0400
X-AuditID: cbfee690-b7fb56d000003439-35-5386d858ff24
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        tony@atomide.com, "'Rob Herring'" <robh+dt@kernel.org>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1401345500-20188-1-git-send-email-kishon@ti.com>
 <1401345500-20188-17-git-send-email-kishon@ti.com>
In-reply-to: <1401345500-20188-17-git-send-email-kishon@ti.com>
Subject: Re: [PATCH v2 16/18] ARM: OMAP: Enable PCI for DRA7
Date: Thu, 29 May 2014 15:48:55 +0900
Message-id: <000601cf7b0a$0fbce200$2f36a600$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac97CRvlfGJQZxqcRBCno8vBNPf9OAAAMKzQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t8zI92IG23BBrOmiVj8nXSM3eLlIU2L
	+UfOsVr0v1nIanF54SVWiwtPe9gsNj2+xmqxsG0Ji8XlXXPYLGYv6WexODvvOJvF0usXmSwm
	TF/LYtG69wi7xf4rXg78HmvmrWH0+P1rEqPHt6+TWDwu9/UyeWxa1cnmsXlJvUffllWMHsdv
	bGfy+LxJLoAzissmJTUnsyy1SN8ugSvj8/kHbAUrOCt2LrjM1MB4lL2LkZNDQsBE4viz01C2
	mMSFe+vZuhi5OIQEljFKfDq/mhGm6O32C6wQiemMEseuf2GGcH4zSrz5+RqsnU1ATeLLl8Ng
	toiAjsTC0+vBipgFpjFL7DvwnAkkISRQJDG1+R0ziM0pYC+xZHIHmC0sYCNx4uItVhCbRUBV
	4u6nC2CreQVsJdZPXMAEYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW6A5HECnqks8+qsLcYOR
	xJzbDxghSkQk9r14xwhyj4TAEQ6J1mnHGSF2CUh8m3yIBaJXVmLTAWaIjyUlDq64wTKBUWIW
	ks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQISRkTdjDeO2B9iDEZ
	aP1EZinR5HxgyskriTc0NjOyMDUxNTYytzQjTVhJnFftUVKQkEB6YklqdmpqQWpRfFFpTmrx
	IUYmDk6pBsZqc5GglkChV14bNTqB8XRikUThuvyHvzrmnpI9997RsiJcZs6UU0Es878F2cnv
	jN+z0ddhnpmEzw61htT8/Itv3XfdKFOK1ZnLVC7eHrfGy5zRdNHJmfkWJ6QN4tLnL52ic2Da
	TpNSS71v85/2dU3ymbA9NsOvVM5q1RnGKHuOJ8Guq9zylViKMxINtZiLihMBejYmuS8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsVy+t9jQd2IG23BBodu8ln8nXSM3eLlIU2L
	+UfOsVr0v1nIanF54SVWiwtPe9gsNj2+xmqxsG0Ji8XlXXPYLGYv6WexODvvOJvF0usXmSwm
	TF/LYtG69wi7xf4rXg78HmvmrWH0+P1rEqPHt6+TWDwu9/UyeWxa1cnmsXlJvUffllWMHsdv
	bGfy+LxJLoAzqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUn
	QNctMwfoASWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxufzD9gKVnBW
	7FxwmamB8Sh7FyMnh4SAicTb7RdYIWwxiQv31rN1MXJxCAlMZ5Q4dv0LM4Tzm1Hizc/XYB1s
	AmoSX74cBrNFBHQkFp5eD1bELDCNWWLfgedMIAkhgSKJqc3vmEFsTgF7iSWTO8BsYQEbiRMX
	b4GtYxFQlbj76QIjiM0rYCuxfuICJghbUOLH5HssIDazgJbE+p3HmSBseYnNa94CzeEAOlVd
	4tFfXYgbjCTm3H7ACFEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910iv
	ODG3uDQvXS85P3cTIzghPZPewbiqweIQowAHoxIPr4RsW7AQa2JZcWXuIUYJDmYlEd5Pl4BC
	vCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9Mlnkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4U
	EkhPLEnNTk0tSC2C2cLEwSnVwGjGvrJ78/fpUqeO/no1zX2VvaqAwvNzUml6lnr53PrmjIeF
	yhbZbb/mUV94765HAPd0ef3qzUsqt635u/tYZ4VaTsFpmevL1c5LHIp4f+q/5naTs7rsF6U3
	q+nob86Z8/nPgcU87XWJm7/mbFr/Ndv33rLEOx0fFi04+vj3G8FO+Sf9B0xOmyspsRRnJBpq
	MRcVJwIAgRlriYwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 29, 2014 3:38 PM, Kishon Vijay Abraham I wrote:
> 
> Now that we have added PCIe driver for DRA7 SOCs, enable PCI on
> DRA7 SOCs.
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Kumar Gala <galak@codeaurora.org>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/mach-omap2/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index cb31d43..b179e80 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -75,6 +75,8 @@ config SOC_DRA7XX
>  	select ARM_GIC
>  	select HAVE_ARM_ARCH_TIMER
>  	select IRQ_CROSSBAR
> +	select MIGHT_HAVE_PCI
> +	select ARCH_SUPPORTS_MSI

Hi Kishon,

Please, don't select ARCH_SUPPORTS_MSI, because this kconfig
option was already removed in v3.12 by the commit ebd97be635
('PCI: remove ARCH_SUPPORTS_MSI kconfig option'). So, there is
NO need to select 'ARCH_SUPPORTS_MSI'.

Best regards,
Jingoo Han

> 
>  config ARCH_OMAP2PLUS
>  	bool
> --
> 1.7.9.5

