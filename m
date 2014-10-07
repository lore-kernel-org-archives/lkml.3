Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaJGAqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:46:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59314 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaJGAqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:46:07 -0400
X-AuditID: cbfee68f-f791c6d000004834-f0-543337ccc443
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        pebolle@tiscali.nl, linux-samsung-soc@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1412610430-8647-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1412610430-8647-1-git-send-email-s.nawrocki@samsung.com>
Subject: Re: [PATCH] usb: Remove references to non-existent PLAT_S5P symbol
Date: Tue, 07 Oct 2014 09:46:04 +0900
Message-id: <00d301cfe1c8$1320a8d0$3961fa70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/hfNFCO1v7MOywS06N68ZmQ6PQuAASxScQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zQ90z5sYhBjN3WVg0L17PZnF54SVW
	i8u75rBZzDi/j8li0bJWZotFt84wWxx+087qwO6xf+4ado++LasYPTZuf8Lk8XmTXABLFJdN
	SmpOZllqkb5dAlfGn5abjAXfuCoutGc1MF7h6GLk5JAQMJHY8OItC4QtJnHh3nq2LkYuDiGB
	ZYwSV79sZ4IpWnJmJzuILSQwnVHi73dviKLfjBK7Tn4AK2ITUJP48uUwWJGIgKHEu82bwSYx
	C5xllJj4bwsLRLerxJXuI2BFnAJuEvcOX2EGsYUFvCV+nTsJZHNwsAioSvy8aAYS5hWwlVh/
	7gkjhC0o8WPyPbAxzAJaEut3HmeCsOUlNq95C9YqIaAu8eivLsQJRhILZsxnhSgRkdj34h0j
	yDkSAvfYJY52rQGbwyIgIPFt8iEWiF5ZiU0HmCH+lZQ4uOIGywRGiVlINs9CsnkWks2zkKxY
	wMiyilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMkYvt3MN49YH2IUYCDUYmHd4WWcYgQa2JZ
	cWXuIUZToIsmMkuJJucD00JeSbyhsZmRhamJqbGRuaWZkjjvQqmfwUIC6YklqdmpqQWpRfFF
	pTmpxYcYmTg4pRoYI5dmW2yuztoU2MF45qSTmlSw6IGwBVN8ora1XVov4PHfc5LIv1vhqmeS
	z80qb7rW+3b38SlvWyJDPi9dbr6BL8ZGY/pLXQ0P4fbJP/ed0HnvsPbXN5EtcVs3WdudbvWv
	0b3Llzd1F9Of4pjvp4Xq3yyu6f1a1L9CqeKNya/Zdjcn8Um7a6Y9V2Ipzkg01GIuKk4EAM0n
	g03TAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xoO4Zc+MQg5OLTCyaF69ns7i88BKr
	xeVdc9gsZpzfx2SxaFkrs8WiW2eYLQ6/aWd1YPfYP3cNu0ffllWMHhu3P2Hy+LxJLoAlqoHR
	JiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoBCWFssSc
	UqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxp+Wm4wF37gqLrRnNTBe4ehi5OSQ
	EDCRWHJmJzuELSZx4d56NhBbSGA6o8Tf795djFxA9m9GiV0nPzCBJNgE1CS+fDkM1iAiYCjx
	bvNmNpAiZoGzjBIT/21hgeh2lbjSfQSsiFPATeLe4SvMILawgLfEr3MngWwODhYBVYmfF81A
	wrwCthLrzz1hhLAFJX5Mvgc2hllAS2L9zuNMELa8xOY1b8FaJQTUJR791YU4wUhiwYz5rBAl
	IhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLT
	wTPpHYyrGiwOMQpwMCrx8K7QMg4RYk0sK67MPcQowcGsJMLL9dsoRIg3JbGyKrUoP76oNCe1
	+BCjKdCfE5mlRJPzgakqryTe0NjEzMjSyMzCyMTcXEmc92CrdaCQQHpiSWp2ampBahFMHxMH
	p1QD4ybP2KXV8ie8FhmeTXpbuLymjVPd47JCE7OWi077sRIT/Yg2qZntF35Luc/K8J15O/SY
	R9WfLeZZ4Zfmi1WX8hcvOB64jyWPrfmtRKfqnMX6D/R9P2QeDVRyKuvpm3F+wtUq8cSXRYdk
	1nw/lj9jk21lpHj6tdNLlp2IO9Zww6r6bY7w03UeSizFGYmGWsxFxYkAmicnOx0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 07, 2014 12:47 AM, Sylwester Nawrocki wrote:
> 
> The PLAT_S5P Kconfig symbol was removed in commit d78c16ccde96
> ("ARM: SAMSUNG: Remove remaining legacy code"). There are still
> some references left, fix that by replacing them with ARCH_S5PV210.
> 
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/usb/host/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 82800a7..6f1d48e 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -220,7 +220,7 @@ config USB_EHCI_SH
> 
>  config USB_EHCI_EXYNOS
>         tristate "EHCI support for Samsung S5P/EXYNOS SoC Series"
> -       depends on PLAT_S5P || ARCH_EXYNOS
> +       depends on ARCH_S5PV210 || ARCH_EXYNOS
>         help
>  	Enable support for the Samsung Exynos SOC's on-chip EHCI controller.
> 
> @@ -527,7 +527,7 @@ config USB_OHCI_SH
> 
>  config USB_OHCI_EXYNOS
>  	tristate "OHCI support for Samsung S5P/EXYNOS SoC Series"
> -	depends on PLAT_S5P || ARCH_EXYNOS
> +	depends on ARCH_S5PV210 || ARCH_EXYNOS
>  	help
>  	 Enable support for the Samsung Exynos SOC's on-chip OHCI controller.
> 
> --
> 1.7.9.5

