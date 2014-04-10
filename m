Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513AbaDJESs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:18:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45921 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934556AbaDJESm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 00:18:42 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-97-53461b9811d9
Message-id: <53461FAB.6060303@samsung.com>
Date: Thu, 10 Apr 2014 13:35:55 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, chow.kim@samsung.com
Subject: Re: [PATCH 01/10] ARM: EXYNOS: Cleanup  "mach-exynos/common.h" file
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1396425058-4012-2-git-send-email-pankaj.dubey@samsung.com>
 <53441CF5.80003@samsung.com>
In-reply-to: <53441CF5.80003@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zY90Z0m7BBlNOclksm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NarJ/xmsWB3aOluYfNY/OSeo++LasYPT5vkgtgieKySUnN
	ySxLLdK3S+DK+HJAu2ANd0VT636mBsZuzi5GTg4JAROJY/3tLBC2mMSFe+vZuhi5OIQEljFK
	HH98lRGmaMGxfnYQW0hgOqNEe7cChP2aUeLMSu4uRg4OXgEtiVN9RiBhFgFVia3bX7GC2GwC
	uhJP3s9lBrFFBcIkNk3vA4vzCghK/Jh8D2yviICKxOVT0xlB9jILbGKUuHZ4BtheYQEfifs9
	J1kgDlrCKPF52V+wDk4BTYm1hxrAbGYBa4mVk7YxQtjyEpvXvGUGaZAQOMUucWj+WjaIkwQk
	vk0+xAJyqYSArMSmA8wQj0lKHFxxg2UCo9gsJEfNQjJ2FpKxCxiZVzGKphYkFxQnpRcZ6hUn
	5haX5qXrJefnbmKExFnvDsbbB6wPMSYDrZzILCWanA+M07ySeENjMyMLUxNTYyNzSzPShJXE
	eZMeJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYLy3Nd62qjFOZvr6zM/BXK4/rrJEpkxJ
	fvdccuGGb8mCJ6Vy1zAEOjyK+jEv+Nw/tfmJq9ZLa83zblQX0vvzoqk40HvzWvf7rIn7D3S7
	G5fr+/w5bnbz/JwFu7xPdbnO3+tbzBenPMdj2hb9knlxh75OarG9/DQnd/2ngPeTld+fjdCd
	b919ZIISS3FGoqEWc1FxIgCdHmzGyQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jQd0Z0m7BBgeb2SyWTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3kt1s94zeLA7tHS3MPmsXlJvUffllWMHp83yQWwRDUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaCkUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzPhyQLtgDXdFU+t+pgbGbs4uRk4OCQET
	iQXH+tkhbDGJC/fWs4HYQgLTGSXauxUg7NeMEmdWcncxcnDwCmhJnOozAgmzCKhKbN3+ihXE
	ZhPQlXjyfi4ziC0qECaxaXofWJxXQFDix+R7LCC2iICKxOVT0xm7GLk4mAU2MUpcOzyDESQh
	LOAjcb/nJAtIQkhgCaPE52V/wTo4BTQl1h5qALOZBawlVk7axghhy0tsXvOWeQKjwCwkS2Yh
	KZuFpGwBI/MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAofia9g3FVg8UhRgEORiUe3gPL
	XIOFWBPLiitzDzFKcDArifAqCLkFC/GmJFZWpRblxxeV5qQWH2JMBobBRGYp0eR8YILJK4k3
	NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQZGbzGJhNVenxR4TEvW
	BIS7p8VPq++79ZKjzV/24BxFr+fPletvXHj28+TxML0T4gv6fOWXtBt3RF+9VvBji4Zb99oX
	nX/3tMuXtKzSOvpMzPz3OrHcmtKk9TOufzK8K8mSIb7/1IGZP05L3g+7lpJ55p8rw9SC8t66
	xJJTV68Ur/rS9Xey720/JZbijERDLeai4kQARS6N8yYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 04/09/2014 12:59 AM, Tomasz Figa wrote:
> Hi Pankaj,
>
> On 02.04.2014 09:50, Pankaj Dubey wrote:
>> Remove unused declarations from "mach-exynos/common.h"
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   arch/arm/mach-exynos/common.h |    3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
>> index 9ef3f83..277a83e 100644
>> --- a/arch/arm/mach-exynos/common.h
>> +++ b/arch/arm/mach-exynos/common.h
>> @@ -15,9 +15,6 @@
>>   #include <linux/reboot.h>
>>   #include <linux/of.h>
>>
>> -void mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l1);
>> -
>> -struct map_desc;
>>   void exynos_init_io(void);
>>   void exynos_restart(enum reboot_mode mode, const char *cmd);
>>   void exynos_cpuidle_init(void);
>>
>
> You could also drop a bit more. From the context above I can see that at least 
> exynos_restart() and exynos_init_io() are never used outside of files they are 
> defined in, so they too could be dropped from this header. Looking at rest of 
> the header, there seems to be a lot of similar definitions. If cleaning up the 
> header anyway, could you take care of them as well?
>

Thanks for review.
Sure, I will take care of other functions which are not required in this header
file in next version.

> Best regards,
> Tomasz
>


-- 
Best Regards,
Pankaj Dubey

