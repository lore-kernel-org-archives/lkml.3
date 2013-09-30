Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab3I3Cez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 22:34:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35589 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3I3Cex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 22:34:53 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-7a-5248e33ba60e
Date: Mon, 30 Sep 2013 11:34:34 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Olof Johansson <olof@lixom.net>
Cc: Sean Paul <seanpaul@chromium.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Hyunwoong Kim <khw0178.kim@samsung.com>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>
Subject: Re: [PATCH v6 07/12] ARM: EXYNOS: remove system mmu initialization
 from exynos tree
Message-id: <20130930113434.4890db899def8d5797567aa4@samsung.com>
In-reply-to: <CALiw-2HwQvpHCoJw0JyGn87ZV1vuvqMtPv8i+AcVGQHnAKtEJw@mail.gmail.com>
References: <003a01cde30b$e13c1910$a3b44b30$%cho@samsung.com>
 <CAOw6vbJfi7UhwxgFKmMzO91fnywWZNTRVDLLSWQOkbbU=C5ndA@mail.gmail.com>
 <20130930093500.ffa527f8f5f004e02a9cb187@samsung.com>
 <CAOw6vbKSQ2xTj7__D5F40vRLxU5Yt1NH4zEp4WcRtB1rVK5gQQ@mail.gmail.com>
 <20130930105234.73b5380ec08bf4cc6b2c9677@samsung.com>
 <CALiw-2HwQvpHCoJw0JyGn87ZV1vuvqMtPv8i+AcVGQHnAKtEJw@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zQ13rxx5BBq3H2CwW7Le26Jy9gd2i
	d8FVNovGexPYLDY9vsZqcXnXHDaLGef3MVmcuv6ZzeLCio3sFlMWHWa1uLvhLKNFy/VeJgce
	jycH5zF5zG64yOJx59oeNo/NS+o9Jt9Yzuhx5UQTq0ffllWMHp83yQVwRHHZpKTmZJalFunb
	JXBlLGjVLpjDWTHzZFkD43T2LkZODgkBE4mXK84zQ9hiEhfurWfrYuTiEBJYxihx9+1RuKKr
	N84xQiSmM0rMvLOaHcKZxCRxoOMCWBWLgKrEtHcLmEBsNgEtidVzjzOC2CICyhJP2i4xgzQw
	C7xklli/dRZQAweHsECcxPkdpiA1vAKOEhN2XmUFsTkFgiVurNgNtaCJWWJX5zFGiDMsJC40
	dbBDNAhK/Jh8jwXEZgZatnlbEyuELS+xec1bsGUSAq0cEksvNjBDXCcg8W3yIRaQxRICshKb
	DkD9LClxcMUNlgmMYrOQjJ2FZOwsJGMXMDKvYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJ
	4f4djHcPWB9iTAZaOZFZSjQ5H5gC8kriDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1O
	TS1ILYovKs1JLT7EyMTBKdXAqLeb3Z658VFf9eZZN2oLjhldr945v8bj4ULD1fduSKT/UJY4
	YmX6xTJBSObWRi2/TYvr7l1zuuZ9QWv37XP3N/9YWhTitohZP+Nto5KZzUk54/Dkt5lcdvEP
	6mJnLEvU6z9S2n5oyrpJCtdsOm7+P+/xmvPL4hyXN+mfVHa/ld317k7qeyZnNiWW4oxEQy3m
	ouJEAEqxzy73AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jQV3rxx5BBlt2M1os2G9t0Tl7A7tF
	74KrbBaN9yawWWx6fI3V4vKuOWwWM87vY7I4df0zm8WFFRvZLaYsOsxqcXfDWUaLluu9TA48
	Hk8OzmPymN1wkcXjzrU9bB6bl9R7TL6xnNHjyokmVo++LasYPT5vkgvgiGpgtMlITUxJLVJI
	zUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBulZJoSwxpxQoFJBYXKyk
	b4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLGgVbtgDmfFzJNlDYzT2bsYOTkkBEwkrt44xwhh
	i0lcuLeerYuRi0NIYDqjxMw7q9khnElMEgc6LoB1sAioSkx7t4AJxGYT0JJYPfc4WLeIgLLE
	k7ZLzCANzAIvmSXWb50F1MDBISwQJ3F+hylIDa+Ao8SEnVdZQWxOgWCJGyt2Qy1oYpbY1XkM
	6gwLiQtNHewQDYISPybfYwGxmYGWbd7WxAphy0tsXvOWeQKjwCwkZbOQlM1CUraAkXkVo2hq
	QXJBcVJ6rqFecWJucWleul5yfu4mRnCCeCa1g3Flg8UhRgEORiUe3gnLPYKEWBPLiitzDzFK
	cDArifAuTwIK8aYkVlalFuXHF5XmpBYfYkwGBsdEZinR5Hxg8soriTc0NjEzsjQyszAyMTcn
	TVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsYJp/WZFwR8vZu2Z96v9fV370gHvfK1vN25
	NKS4N9jnwmrFLTPPHt1wzfuI9FNLZSPtyJ8t3pkb9KdNYahhOz15+/VY6638ZlfeHHhwWr+e
	xTPsQPFtU9FbB+ouq3G/XGi8fmuhwIzMuZfrAluvbj6wZYnaafE1rxYt2HQ58sXPBd/WL8gU
	sX+aoMRSnJFoqMVcVJwIANPKqi1UAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Sep 2013 19:03:06 -0700, Olof Johansson wrote:
> Hi,
> 
> 2013/9/29 Cho KyongHo <pullip.cho@samsung.com>:
> 
> > Ah, I remember that this is merged.
> > I agreed to merge this patch because iommu driver need to be completely changed.
> > Whenever I change exynos-iommu driver, synchronizing samsung-next and iommu-next
> > branches is a big challenge.
> > Thus I decided to remove dependencies to samsung-next branch.
> > But I didn't know that the rest of the new driver is not merged soon. :(
> > I am sorry about that.
> >
> > new patch (v10) will be posted soon.
> 
> Will the v10 patch set be incremental based on v6?
> 
The single patch 07/12 is merged to mainline from v6 patches.
v10 patch is more advanced than v6.
Of course, much more is changed.
You can refer the v9 patch what is changed since v6.

> How have you tested v10 on mainline?
> 

I just test if the System MMU is correctly enabled and disabled,
if page table is correctly maintained.
It is done with IOMMU API call from custom driver/device and applications.

The test does not involve working with master IPs such as MFC, FIMC and so on.

> Thanks,
> 
> -Olof
