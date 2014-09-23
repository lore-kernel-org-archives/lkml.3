Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaIWGRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:17:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8820 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaIWGRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:17:22 -0400
X-AuditID: cbfee691-f79b86d000004a5a-ec-542110703da2
From: Kukjin Kim <kgene@kernel.org>
To: "=?utf-8?Q?'Andreas_F=C3=A4rber'?=" <afaerber@suse.de>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Daniel Drake'" <drake@endlessm.com>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1410954633-27025-1-git-send-email-javier.martinez@collabora.co.uk>
 <1410954633-27025-3-git-send-email-javier.martinez@collabora.co.uk>
 <CAD=FV=W7xJ01m2oLtuDnogOmrpwpztbir=59oSWU6oojFYUWKw@mail.gmail.com>
 <5419ADF9.3010509@suse.de>
In-reply-to: 
Subject: RE: [PATCH 2/2] ARM: dts: Add rtc_src clk for s3c-rtc on
 exynos5250-snow
Date: Tue, 23 Sep 2014 15:17:17 +0900
Message-id: <00f801cfd6f6$07e10500$17a30f00$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLbS3wcopW0Zexicw3nUqbcbogB6QLhhACVAbb1ttEBy1EbVJnDBZWAgAEwYEA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zfd0CAcUQg3cT+S2aNxVbXP/ynNXi
	7LKDbBaP5j9mtjj6u8Bi0+NrrBaXd81hs5hxfh+TA4fH7IaLLB5/n19n8Vj0Pctj85J6j74t
	qxg9Np+u9vi8SS6APYrLJiU1J7MstUjfLoErY8eFDUwF3TwV744vYWxg/MvRxcjJISFgIrHp
	dD8zhC0mceHeerYuRi4OIYFljBL3lqxngik6MncfVGIRo0Tz2YvMEM5fRomtf7eydDFycLAJ
	KEs0NumDNAgLaEks3NLEAmKLCCRL7J27BayeWWACk8TWVfsYQRJCAj8ZJbb/qwKxOQV4JNb9
	6WSGaA6WWLXyIJjNIqAq8X/LJFYQm1fAQqJzfS8zhC0o8WPyPbC9zALqElOm5IKEmQW0JZ68
	u8AKcbSCxI6zrxkhbvCTOLx8ERNEjYjEvhfvGCFqWjkkpjawQKwSkPg2+RDYSAkBWYlNB6CB
	IilxcMUNlgmMkrOQLJ6FsHgWksWzkCxYwMiyilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMk
	zifuYLx/wPoQowAHoxIPr8cahRAh1sSy4srcQ4ymQAdNZJYSTc4HJpO8knhDYzMjC1MTU2Mj
	c0szJXFeHemfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYzR7oprMmWvROmG748n8qNzcv
	y423D9ZZf71y5KmsxMoazp4ZEzwlZjyymDXvfHe0qoPqdQ9rAX8nR3mWB72c7748CZ+uv0nw
	gFbKnG22tu9WPFbw/K8m5e7km+W1QPSKyqN5Ys4ykSF9iRXSj73ruvd+PPJp4g2PK6n93Tw+
	BaVqZ/hWuM1WYinOSDTUYi4qTgQAoUwXee4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd0CAcUQg3mXuSyaNxVbXP/ynNXi
	7LKDbBaP5j9mtjj6u8Bi0+NrrBaXd81hs5hxfh+TA4fH7IaLLB5/n19n8Vj0Pctj85J6j74t
	qxg9Np+u9vi8SS6APaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
	VsnFJ0DXLTMH6CIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8aOCxuY
	Crp5Kt4dX8LYwPiXo4uRk0NCwETiyNx9bBC2mMSFe+uBbC4OIYFFjBLNZy8yQzh/GSW2/t3K
	0sXIwcEmoCzR2KQP0iAsoCWxcEsTC4gtIpAssXfuFrB6ZoEJTBJbV+1jBEkICfxklNj+rwrE
	5hTgkVj3p5MZojlYYtXKg2A2i4CqxP8tk1hBbF4BC4nO9b3MELagxI/J98D2MguoS0yZkgsS
	ZhbQlnjy7gIrxNEKEjvOvmaEuMFP4vDyRUwQNSIS+168Y5zAKDwLyaRZCJNmIZk0C0nHAkaW
	VYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBaeSZ9A7GVQ0WhxgFOBiVeHg91yiECLEmlhVX
	5h5ilOBgVhLhLZkIFOJNSaysSi3Kjy8qzUktPsRoCvTnRGYp0eR8YIrLK4k3NDYxM7I0MrMw
	MjE3VxLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAaHZa5OilH3d8NY3n7T/rf263cMm28mRn
	3qBUK4UbxwVFTbaknxT466ay0Vf6lZuM/AFbybpLjUeWNpZMtEpaLDZ7e0elTXSu6daPiaU6
	FVdeWK0/YSBxss1s6qS/r5yn+CU/uHvVrr8hgfV5xJqrC+7JLkurOqN1c+Wm1Yk3A4xy9h1o
	8nj3SomlOCPRUIu5qDgRANCf4QY5AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin Kim wrote:
> > 
> Andreas Färber wrote:

[...]

> > > Kukjin: Andreas's patch series was Reviewed long ago I think and by
> > > now I'd imagine it's got some conflicts due to it not having been
> > > applied in a timely fashion.  Perhaps you could fix it up for Andreas
> > > (since he's already rebased it several times) and land it?
> > >
> > > If I had to guess, outstanding from Andreas's series (patchwork IDs listed):
> > >
> > > 4751131 New          [v7] ARM: dts: Prepare node labels for exynos5250
> > > 4664801 New          [v6,04/10] ARM: dts: Clean up exynos5250-snow
> > > 4664771 New          [v6,05/10] ARM: dts: Fill in bootargs for exynos5250-snow
> > > 4664731 New          [v6,06/10] ARM: dts: Clean up exynos5250-smdk5250
> > > 4664751 New          [v6,07/10] ARM: dts: Clean up exynos5250-arndale
> > > 4664711 New          [v6,08/10] ARM: dts: Fix apparent GPIO typo in
> > > exynos5250-arndale
> > > 4664681 New          [v6,09/10] ARM: dts: Simplify USB3503 on exynos5250-arndale
> > > 4664691 New          [v6,10/10] ARM: dts: Add exynos5250-spring device tree
> >
> > Yes, Kukjin told me not to resend anything, and I haven't heard back
> > from him since his Kernel Summit trip.
> >
> Sorry about that and I thought I took them :( I'll sort them out tonight
> including this series together.
> 
Hmm...since some conflicts with dp and mmc_slot related patches, I couldn't,
but Andreas' patches will be handled by tonight :(

- Kukjin

