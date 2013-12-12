Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3LLLlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:41:17 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38115 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3LLLlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:41:13 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-f8-52a9a0d75325
From: Tomasz Figa <t.figa@samsung.com>
To: Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Kgene Kim <kgene.kim@samsung.com>,
        Patch Tracking <patches@linaro.org>, linaro-kernel@lists.linaro.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH CFT] ARM:S5P64X0: Enable ARM_PATCH_PHYS_VIRT and
 AUTO_ZRELADDR by default
Date: Thu, 12 Dec 2013 12:40:59 +0100
Message-id: <3126277.U19MiHChc4@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <CAAunhULO5n3rf5_Q+HwExd=kadsPC_rTz9oP8kXKM7krBetbdQ@mail.gmail.com>
References: <1386825152-398-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
 <26167386.hX5eWUjT6T@flatron>
 <CAAunhULO5n3rf5_Q+HwExd=kadsPC_rTz9oP8kXKM7krBetbdQ@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xy7rXF6wMMtj6X9Ti/6PXrBa9C66y
	Wbw/9IzZYsqf5UwWmx5fY7W4vGsOm8WM8/uYLG5f5rXY+MLfYsrhLywWh9+0s1qs2vWH0YHH
	o6W5h81j56y77B53ru1h89i8pN7j9r/HzB59W1Yxemy/No/Z4/MmuQCOKC6blNSczLLUIn27
	BK6MtTf3sBZs4ajY1f2KrYHxJlsXIyeHhICJxNtDTawQtpjEhXvrgeJcHEICSxklXv1tYYRw
	upgk1jz/wQRSxSagJvG54RFYt4iAt8Tsu9vZQWxmgUXMEt0vgrsYOTiEBeIl5s/IBQmzCKhK
	XPuxFKyVV0BTou/uR7ByfgF1iXfbnoLFRQXcJF7s2wIW5xQIluj/ep8dYu9uRok1yw9DNQtK
	/Jh8jwVil7zEvv1TWSFsLYn1O48zTWAUnIWkbBaSsllIyhYwMq9iFE0tTS4oTkrPNdQrTswt
	Ls1L10vOz93ECImkLzsYFx+zOsQowMGoxMP74uCKICHWxLLiytxDjBIczEoivC6pK4OEeFMS
	K6tSi/Lji0pzUosPMTJxcEo1MJZsu/HdTKjt9MLT72KmTVzfyVmyNH7mwQtLTh0O5vjpuWP+
	gxcyv3XXZ65LzM9efOex1VezKqd7Ei089xI3ruUyfJJvVPFD7JtP3/vHESe3h+cJsE6U3VCy
	2FH37MTfb2POnbssurAjpjWG7XY1+7aGjTt3fF+1+3xN4ptLirtn8rvdOdJfUPNXiaU4I9FQ
	i7moOBEAj77/WoICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 of December 2013 16:33:46 Panchaxari Prasannamurthy Tumkur wrote:
> Hi Tomasz
> 
> > Could you explain the purpose of this change on S5P64x0?
> >
> > This is actually quite a poor platform choice. As of today, the kernel
> > is stuck with supporting just SMDK6440/6450 boards, which are proprietary
> > development boards and it doesn't look like any further boards will show
> > up in future. Kukjin has actually proposed removing support for this
> > platform at all and I consider this reasonable.
> >
> > Kukjin, should we proceed with removal?
> 
> The purpose of this patch is with the greater intent of consolidating
> ARM-32 kernel. Which means a generic kernel for ARM-32 processors.

OK. So do you have plans to send similar patches for other, more active
(and closer to having multiplatform support) platforms, such as s3c64xx,
s5pv210 and exynos?

In case of s5p64x0 probably the only person capable of testing it is
Kukjin, as we don't have any other active people with boards based on
these SoCs.

Best regards,
Tomasz

