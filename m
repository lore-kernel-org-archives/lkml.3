Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaFJLnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:43:50 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39954 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaFJLns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:43:48 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-23-5396ef722a28
Message-id: <5396EF63.8030506@samsung.com>
Date: Tue, 10 Jun 2014 13:43:31 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        yg1004.jang@samsung.com, vikas.sajjan@samsung.com
Subject: Re: [PATCH v4 01/11] ARM: EXYNOS: Make exynos machine_ops as static
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
 <1399704998-13321-2-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1399704998-13321-2-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xa7pF76cFGxy9zWKxbNJdNoveBVfZ
	LDY9vsZqcXnXHDaLGef3MVncvsxrsWjrF3aLm8+2M1nsaFnN4sDp0dLcw+axeUm9R9+WVYwe
	nzfJBbBEcdmkpOZklqUW6dslcGVsXbaEveAzc8WZGVOYGxgnMHcxcnJICJhInOi/zQZhi0lc
	uLceyObiEBJYyijx4PZWRpCEkMBnRol5r2RBbF4BLYmV006zgtgsAqoSx060g9lsAmoSnxse
	gQ3iB6pZ03SdpYuRg0NUIELi8QUhiFZBiR+T77GAzBcRmMIocbFnGdh8ZoEaiQWdm1lAbGEB
	H4lZbVNYII5oB9r7fQ3YAk4BT4nlR7tZIBp0JPa3TmODsOUlNq95yzyBUXAWkiWzkJTNQlK2
	gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIFHzZwbj4mNUhRgEORiUeXg6dacFCrIll
	xZW5hxglOJiVRHi/nAQK8aYkVlalFuXHF5XmpBYfYmTi4JRqYNR/88m8+GXrgS2RT62rTU18
	m3sfPr74o3rRsU3t3GcY7jD5WeRZNl3Vrvct/lqxJaD5/MKzS5RqQzhN3j/4WFERZ/8oWeF9
	Om/StN2sBXOfqX195fbn1a+Vy5ge7VPUUs37d6X29i8tLZtZ0mwnpaYdZX3mYJE+7/Hjo+Xp
	tpnb4vSaXJUZ3yqxFGckGmoxFxUnAgCIrUCTYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 10.05.2014 08:56, Pankaj Dubey wrote:
> As machine function ops are used only in this file let's make
> them static. Also remove unused and unwanted declarations from
> common.h.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/common.h |    8 --------
>  arch/arm/mach-exynos/exynos.c |    6 +++---
>  2 files changed, 3 insertions(+), 11 deletions(-)
> 

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
