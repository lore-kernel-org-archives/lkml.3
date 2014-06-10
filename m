Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaFJN4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:56:49 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39810 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaFJN4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:56:47 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-32-53970e9c3643
Message-id: <53970E8E.5030408@samsung.com>
Date: Tue, 10 Jun 2014 15:56:30 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, arnd@arndb.de
Subject: Re: [PATCH v3 4/6] ARM:  EXYNOS: Remove unused header inclusion from
 hotplug.c
References: <1399706287-13919-1-git-send-email-y@samsung.com>
 <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
 <1399706419-13976-5-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1399706419-13976-5-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xy7pz+KYHGyz5oGnxd9IxdoveBVfZ
	LDY9vsZqcXnXHDaLGef3MVks2vqF3YHN4/evSYwem5fUe/RtWcXo8XmTXABLFJdNSmpOZllq
	kb5dAlfGpLfvmAvesVZcbr7N1MB4j6WLkYNDQsBEovNNTBcjJ5ApJnHh3nq2LkYuDiGBpYwS
	J3esY4dwPjNKXG69yAZSxSugJbFjxi0WEJtFQFViWfdFMJtNQE3ic8MjsBp+oJo1TdfBFogK
	REg8viAE0Soo8WMyyF4uDhGBKYwSF3uWMYLUMAtoSFx95Q9SIywQKbF2zn5WiL27GSVW7p4E
	NpNTwFPiy91WRhCbWUBHYn/rNDYIW15i85q3zBMYBWch2TELSdksJGULGJlXMYqmliYXFCel
	5xrqFSfmFpfmpesl5+duYoSE+ZcdjIuPWR1iFOBgVOLh5dCZFizEmlhWXJl7iFGCg1lJhLft
	L1CINyWxsiq1KD++qDQntfgQIxMHp1QDY2N3WYSCQMujs5opS60Ob4wwKdufvTfP2p1j1xnz
	1odvqs4umP3if7pFS6jEuW8xJRICXqsa3myzvZTGLBS50cXkclhX7TfOfTafG9of25V+9a3L
	a9znIPPOonNK2A/G2tRwYeb8ny05MTOesPHsM5vFpWQ0d5dmkpABj07biT3CJUKFUseUWIoz
	Eg21mIuKEwFF1kPDUQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 10.05.2014 09:20, Pankaj Dubey wrote:
> This patch removed "plat/cpu.h" inclusion from hotplug.c as it
> is not required.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/hotplug.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
> index 0243ef3..5e19601 100644
> --- a/arch/arm/mach-exynos/hotplug.c
> +++ b/arch/arm/mach-exynos/hotplug.c
> @@ -19,8 +19,6 @@
>  #include <asm/cp15.h>
>  #include <asm/smp_plat.h>
>  
> -#include <plat/cpu.h>
> -
>  #include "common.h"
>  #include "regs-pmu.h"
>  
> 

I don't see this header being included in current linux-next.

Best regards,
Tomasz
