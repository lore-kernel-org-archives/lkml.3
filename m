Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaFJNz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:55:28 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56557 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaFJNz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:55:26 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-8b-53970e4c30ed
Message-id: <53970E3D.9080501@samsung.com>
Date: Tue, 10 Jun 2014 15:55:09 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, arnd@arndb.de,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: [PATCH v3 3/6] ARM: EXYNOS: Remove soc_is_exynos4/5 from exynos.c
References: <1399706287-13919-1-git-send-email-y@samsung.com>
 <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
 <1399706419-13976-4-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1399706419-13976-4-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xq7o+fNODDTqfc1n8nXSM3aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd3i2IwljA4cHi3NPWwev39NYvS4c20Pm8fmJfUe
	fVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlbF0xnymgpVsFWtPXWRrYJzK2sXIySEhYCLx8XUv
	lC0mceHeejYQW0hgKaPE979ANheQ/ZlR4vHC1WBFvAJaEi9e7QMrYhFQlfhypwEsziagJvG5
	4RFYnB+oZk3TdZYuRg4OUYEIiccXhCBaBSV+TL7HAjJTRGAKo8TFnmWMIAlmgXqJ3hV/wXqF
	Bfwkfl34yAixeDfQ4tcvmUASnAKeEm39C9kgGnQk9rdOg7LlJTavecs8gVFwFpIls5CUzUJS
	toCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSDx83cG49JjVIUYBDkYlHl4D/2nBQqyJ
	ZcWVuYcYJTiYlUR42/4ChXhTEiurUovy44tKc1KLDzEycXBKNTBKzFbl9ptt6WPL9vjtg93H
	36jOM1h0ddXVX5tXfF/46v+Oows8z2/5KLut6+MLPqVbJV+363TdfuRyem+8WE+baTNTYOvO
	U3wsW06/kWMtNVsQLMef+nH93T9fJTZpG38v5i8+N7W+5ZftnGctq/fbVh5ovnpi0bfvMS0s
	a+8fvS6+MG69s5j2bCWW4oxEQy3mouJEAKI5fU1lAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.05.2014 09:20, Pankaj Dubey wrote:
> This patch removes usage of soc_is_exynos4/5 from exynos.c.
> For this we need to separate machine descriptors for exynos4
> and exynos5. While doing this patch does some consolidation also.
> 
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Thomas Abraham <thomas.abraham@linaro.org>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/exynos.c            |   52 +++++++++++++++++++-----------
>  arch/arm/plat-samsung/include/plat/cpu.h |    3 --
>  2 files changed, 33 insertions(+), 22 deletions(-)
> 

I don't think this is needed. All those static mappings should just go
away, which will also eliminate the need to have separate machine
descriptor or soc_is_exynos{4,5}() macros.

Best regards,
Tomasz
