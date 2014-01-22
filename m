Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaAVIJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 03:09:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:64924 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaAVIJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:09:00 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-ac-52df7c9567d0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001cf1687$a0e5e250$e2b1a6f0$%han@samsung.com>
In-reply-to: <000001cf1687$a0e5e250$e2b1a6f0$%han@samsung.com>
Subject: Re: [PATCH] Documentation: devicetree: mct: Fix counter bit of CPU
 local timers
Date: Wed, 22 Jan 2014 17:08:53 +0900
Message-id: <000101cf1749$30ae3b50$920ab1f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8Wh6CHvecSL6aTSbyl5f0jq8u5rgAwQWfg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t8zY92pNfeDDPaf1bGY91nW4vLCS6wW
	vQuuslksbFvCYnF51xw2ixnn9zFZrJ/xmsVi86apzBbHZixhdOD0uHNtD5vHu3Pn2D36tqxi
	9Pi8SS6AJYrLJiU1J7MstUjfLoEr48rebsaCrTwVW+b/YGlgnMvVxcjBISFgIrHtt0QXIyeQ
	KSZx4d56ti5GLg4hgWWMEpuWnmaHqbnxKQAiPp1R4srvVawQzi9GiTd9M1lButkE1CS+fDnM
	DmKLCBhIvD79mx2kiFlgFZPEu23nwYqEBGwlFm5YwwJicwrYSWzb9o4NxBYWiJLYdmwNWA2L
	gKrEga+nwWxeoPpTq1ewQNiCEj8m3wOzmQW0JNbvPM4EYctLbF7zlhniUnWJR391IW4wknj0
	disjRImIxL4X7xhB7pEQ+MouMfvDJmaIXQIS3yYfYoHolZXYdIAZEhKSEgdX3GCZwCgxC8nm
	WUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihETxxB2M9w9YH2JMBlo/
	kVlKNDkfmATySuINjc2MLExNTI2NzC3NSBNWEudNf5QUJCSQnliSmp2aWpBaFF9UmpNafIiR
	iYNTqoExyoJ3ZW+agpBPrKbxvMDqQqt889C5prVe6yZsjDNunXT30s0Uc5ODLdcDK3I0y6b7
	qjyWVtaL91NwPP5wxeGp1arej3o/Bz1c+e2d/R/+wtnh93ex+fpeM7NwUHp95+qrm5kbVk/o
	5IrQ5uZyDLri9mgNQ+fTLft7p5fInM6U4ygufuW9aLcSS3FGoqEWc1FxIgBurnlV+AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jQd2pNfeDDCa8UbeY91nW4vLCS6wW
	vQuuslksbFvCYnF51xw2ixnn9zFZrJ/xmsVi86apzBbHZixhdOD0uHNtD5vHu3Pn2D36tqxi
	9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DX
	LTMH6BYlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8aVvd2MBVt5KrbM
	/8HSwDiXq4uRg0NCwETixqeALkZOIFNM4sK99WxdjFwcQgLTGSWu/F7FCuH8YpR40zeTFaSK
	TUBN4suXw+wgtoiAgcTr07/ZQYqYBVYxSbzbdh6sSEjAVmLhhjUsIDangJ3Etm3v2EBsYYEo
	iW3H1oDVsAioShz4ehrM5gWqP7V6BQuELSjxY/I9MJtZQEti/c7jTBC2vMTmNW+ZIa5Wl3j0
	VxfiBiOJR2+3MkKUiEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07M
	LS7NS9dLzs/dxAhOEs+kdzCuarA4xCjAwajEwxuw616QEGtiWXFl7iFGCQ5mJRHe5UX3g4R4
	UxIrq1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5jA8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgk
	kJ5YkpqdmlqQWgSzhYmDU6qBUeXj1P8O7qlT4rkanf5k/hV/OrHn3aOT2bULg59Pl5++8deT
	IMdZkSFWGmlxfGcVejuOG8guvna7of3hqo3VPO9cTQO7L7cYyS9TL5nlnXr1uHy4o9f+1Llr
	d6Xcn6/Kpxj+9NYZlvb/mm2s2y0/Zh4wi3pjNqlla2KAnMqr/DY2V/ernVO/KrEUZyQaajEX
	FScCAKGCxj5WAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 21, 2014 6:03 PM, Jingoo Han wrote:
> 
> According to the datasheet of Exynos SoCs, the counter bit
> of CPU local timers is 31-bit, not 32-bit; thus, it should
> be fixed.

Please, ignore this patch.
There is a 31-bit counter in CPU local timers; however,
FRC (free running down-counters) of CPU local timers is
32-bit. Thus, there is no need to fix it.
Thank you.

Best regards,
Jingoo Han

> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt
> b/Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt
> index 167d5da..8c77791 100644
> --- a/Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt
> +++ b/Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt
> @@ -3,7 +3,7 @@ Samsung's Multi Core Timer (MCT)
>  The Samsung's Multi Core Timer (MCT) module includes two main blocks, the
>  global timer and CPU local timers. The global timer is a 64-bit free running
>  up-counter and can generate 4 interrupts when the counter reaches one of the
> -four preset counter values. The CPU local timers are 32-bit free running
> +four preset counter values. The CPU local timers are 31-bit free running
>  down-counters and generate an interrupt when the counter expires. There is
>  one CPU local timer instantiated in MCT for every CPU in the system.
> 
> --
> 1.7.10.4


