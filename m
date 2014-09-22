Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaIVExZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 00:53:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63520 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaIVExX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 00:53:23 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-52-541fab4122c9
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, s.nawrocki@samsung.com, mturquette@linaro.org,
        "'Chander Kashyap'" <k.chander@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>
References: <1410328565-25122-1-git-send-email-pankaj.dubey@samsung.com>
 <54122962.5020903@gmail.com>
In-reply-to: 
Subject: RE: [PATCH] clk: samsung: exynos5260: fix typo in clock name
Date: Mon, 22 Sep 2014 10:25:28 +0530
Message-id: <001b01cfd621$738ed8c0$5aac8a40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGjcMNdvmvoOe4ebVgYUdsP7pvQZwFqBtAdnEqku5CAD2rAsA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsWyRsSkStdxtXyIwbIpKhaP1yxmsli1YQmL
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLJ5OuMhmcfhNO6vFql1/GB04PXbOusvucefaHjaPzUvq
	Pfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugStj+51HzAXtbBUz79xkbWB8xtLFyMkhIWAise7B
	HjYIW0ziwr31YLaQwFJGiZ2302BqHlzZz9rFyAUUn84o8fP7eiYI5y+jxKM7/awgVWwCuhJP
	3s9lBkmICExhlFi5uRXMYRZYzChx9ulOFoi56RKX9k8GszkFeCTW/elkBrGFBVwljrTcALNZ
	BFQl1s3sZQKxeQUsJR5eO8kCYQtK/Jh8D8xmFtCSWL/zOBOELS+xec1bZohbFSR2nH3NCGKL
	CDhJHH6yBKpGXGLSg4fsEDVf2SU2tuhD7BKQ+Db5ENBMDqC4rMSmA1BjJCUOrrjBMoFRYhaS
	zbOQbJ6FZPMsJBsWMLKsYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAiM6dP/nk3YwXjvgPUh
	RgEORiUe3h8t8iFCrIllxZW5hxhNgS6ayCwlmpwPTBx5JfGGxmZGFqYmpsZG5pZmSuK8r6V+
	BgPDMLEkNTs1tSC1KL6oNCe1+BAjEwenVANjhObrd8/tzMtfHKn+JODZ/l4x4EGy1GJN7t6N
	OivtLP8LHa2d8Fvc6CF30aOkGfHGRg8/fW/6+aOfu7Fze9jKCEvjw2FNr/Zo6DlfN/v59eBZ
	k+VPJb6vMrhWdWGNkINyD3uSZ3GXRdbGitBVvhGL+DhrVQ+0/su1vdGZFPjDK7b6UPZKX28l
	luKMREMt5qLiRADOuUBb5AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQV3H1fIhBqcfyFg8XrOYyWLVhiUs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsng64SKbxeE37awWq3b9YXTg9Ng56y67x51re9g8Ni+p
	9+jbsorR4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRb
	JRefAF23zBygg5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGdvvPGIu
	aGermHnnJmsD4zOWLkZODgkBE4kHV/azQthiEhfurWfrYuTiEBKYzijx8/t6JgjnL6PEozv9
	YFVsAroST97PZQZJiAhMYZRYubkVzGEWWMwocfbpTrC5QgLpEpf2TwazOQV4JNb96WQGsYUF
	XCWOtNwAs1kEVCXWzexlArF5BSwlHl47yQJhC0r8mHwPzGYW0JJYv/M4E4QtL7F5zVtmiFsV
	JHacfc0IYosIOEkcfrIEqkZcYtKDh+wTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqu
	kV5xYm5xaV66XnJ+7iZGcNJ4Jr2DcVWDxSFGAQ5GJR7eHy3yIUKsiWXFlbmHGCU4mJVEeI/m
	AIV4UxIrq1KL8uOLSnNSiw8xmgJ9OpFZSjQ5H5jQ8kriDY1NzE2NTS1NLEzMLJXEeQ+2WgcC
	wyuxJDU7NbUgtQimj4mDU6qB0WtCfusGk40tWgfELhecf6jRElAZnSrcfavcamrLvFhniyiV
	4LvSF6Z+Xm595u66V4JC8dV3Kj5LP9re6PWad/uzzwJztYsqk/p424Ul5ufGqqj+j75ns455
	U3kE+9fVKy75lZ+73/qI/XxKnXD68Q+fGCSfyn70s32/wS74+Oyr+bLTb6ptUmIpzkg01GIu
	Kk4EAMFZvL4wAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

Will you please take this patch and following three Exynos3250 clock fixes
in your tree.

1: clk: samsung: exynos3250: fix width field of mout_mmc0/1
   https://lkml.org/lkml/2014/9/5/265
2: clk: samsung: exynos3250: fix width and shift of div_spi0_isp clock
   https://lkml.org/lkml/2014/9/9/364
3: clk: samsung: exynos3250: fix mout_cam_blk parent list
  https://lkml.org/lkml/2014/9/6/41

Thanks,
Pankaj Dubey

> 
> Please add my sign-off as
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> 
> >
> > Missed your sign-off? You can reply with it inline and I will add it
> > when applying this weekend.
> >
> > P.S. Please keep me on CC when sending patches for Samsung clock
drivers.
> >
> > Best regards,
> > Tomasz

