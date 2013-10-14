Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab3JNAda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 20:33:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18546 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab3JNAd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 20:33:28 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-07-525b3bd0df50
From: Jingoo Han <jg1.han@samsung.com>
To: "'Michael Opdenacker'" <michael.opdenacker@free-electrons.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1381548966-5210-1-git-send-email-michael.opdenacker@free-electrons.com>
In-reply-to: <1381548966-5210-1-git-send-email-michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] ARM: SAMSUNG: remove IRQF_DISABLED
Date: Mon, 14 Oct 2013 09:33:20 +0900
Message-id: <000801cec874$fbc92cb0$f35b8610$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7G/DL/w2mSJ7ZMRTWJhLPetio8AABeD6SA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t8zI90L1tFBBid+mVpMWneAyeLywkus
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfiwYRVbA4cHi3NPWwef1e9YPZ4sukio8fmJfUe
	fVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlfH2026Wgu0sFd1HrjE2MB5h7mLk5JAQMJHYcrCP
	HcIWk7hwbz1bFyMXh5DAMkaJ3z9nsHQxcoAVrW/Jg4hPZ5TY9+kvO4Tzi1Hi4++LrCDdbAJq
	El++HAabJCKQIfGyZQEzSBGzwGtGiTOfN7CAJIQEwiRmv33DCGJzCoRLLPiwF+wMYQFziV1r
	voPVsAioSvT+38wGsplXwFZi/zpjkDCvgKDEj8n3wEqYBbQk1u88zgRhy0tsXvOWGeJQdYlH
	f3VBTBEBI4npq2IgKkQk9r14xwhyjYRAI4fExM1LWCE2CUh8m3wI6kdZiU0HoGEiKXFwxQ2W
	CYwSs5AsnoVk8Swki2chWbGAkWUVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRkgs9+9gvHvA
	+hBjMtD6icxSosn5wFSQVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFqUXxR
	aU5q8SFGJg5OqQbGeN3VPpq/Hu4s5dq9fOMe3pefA4zEA+Q8BL7VP9BzeJzQuUVyeuzO4pZa
	K6mVirvmXNnWuz/qhLeK1r2wi8LKVyJm3/nzInWO/u99krdmqaQ/1A97Ltj9e7ZTs2G22dcM
	ZfPj89vlNfV2xuxLWHiiQuxugzXTJ+11R9O8GNl9F/kvYTGq5c5RYinOSDTUYi4qTgQACqDX
	xfsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jQd0L1tFBBj/eGVpMWneAyeLywkus
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfiwYRVbA4cHi3NPWwef1e9YPZ4sukio8fmJfUe
	fVtWMXp83iQXwBbVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk
	4hOg65aZA3SPkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj7afdLAXb
	WSq6j1xjbGA8wtzFyMEhIWAisb4lr4uRE8gUk7hwbz1bFyMXh5DAdEaJfZ/+skM4vxglPv6+
	yApSxSagJvHly2F2EFtEIEPiZcsCZpAiZoHXjBJnPm9gAUkICYRJzH77hhHE5hQIl1jwYS8z
	iC0sYC6xa813sBoWAVWJ3v+b2UCu4BWwldi/zhgkzCsgKPFj8j2wEmYBLYn1O48zQdjyEpvX
	vIU6Wl3i0V9dEFNEwEhi+qoYiAoRiX0v3jFOYBSahWTQLCSDZiEZNAtJywJGllWMoqkFyQXF
	Sem5RnrFibnFpXnpesn5uZsYwYnimfQOxlUNFocYBTgYlXh4JS5FBgmxJpYVV+YeYpTgYFYS
	4ZX6FhUkxJuSWFmVWpQfX1Sak1p8iDEZ6M2JzFKiyfnAJJZXEm9obGJmZGlkZmFkYm5OmrCS
	OO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYx2kxymhd4/XSO/aPmMq+L3eZnkljzweb3nzdMJ
	GY9fKF43k9nmaHrty9E/H+2YJgWsseZ5KdNy+DMD320PQUn2vJX3v92NNRJJa+hjWDRPuIKZ
	Q87eIPjvM6l5wY8t5h7VOqYzJSpwkSSnYtL6M/le92f5v5voNeXakd4517V+rd/F/fFj3q7b
	SizFGYmGWsxFxYkAhEmB8VgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 12, 2013 12:36 PM, Michael Opdenacker wrote:
> 
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  arch/arm/mach-s3c24xx/dma.c         | 2 +-
>  arch/arm/mach-s3c24xx/simtec-usb.c  | 3 +--
>  arch/arm/mach-s3c64xx/mach-smartq.c | 2 +-
>  3 files changed, 3 insertions(+), 4 deletions(-)

