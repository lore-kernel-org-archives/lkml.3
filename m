Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3KOCAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 21:00:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:45281 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab3KOCAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 21:00:15 -0500
X-AuditID: cbfee68f-b7f836d000001b39-05-5285802d0530
From: Inki Dae <inki.dae@samsung.com>
To: "'Olof Johansson'" <olof@lixom.net>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: "'Kishon Vijay Abraham I'" <kishon@ti.com>, linux-fbdev@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>
References: <1384463364-28864-1-git-send-email-olof@lixom.net>
 <20131115013248.GA6541@kroah.com>
 <CAOesGMh2HvyHimo8=LyZ-R_W_0=XtB37hbnbx_hk0Wq+4CBhuA@mail.gmail.com>
In-reply-to: <CAOesGMh2HvyHimo8=LyZ-R_W_0=XtB37hbnbx_hk0Wq+4CBhuA@mail.gmail.com>
Subject: RE: [PATCH] video: exynos_mipi_dsim: Remove unused variable
Date: Fri, 15 Nov 2013 11:00:13 +0900
Message-id: <01f701cee1a6$6c403110$44c09330$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7hpNLtQlCudoS3TsKH7l+6gNft1AAAXS3g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsWyRsSkQFevoTXI4HAbs0Xz4vVsFhee9rBZ
	nOj7wGpxedccNosZ5/cxWZy6/pnN4vCbdlYHdo/9c9ewe1w50cTq0bdlFaPH8RvbmTw+b5IL
	YI3isklJzcksSy3St0vgyth9Yg1TwSLeimX7HzA1MF7n6mLk5JAQMJGYNvEjK4QtJnHh3nq2
	LkYuDiGBpYwSiz+dZocpatu1mgUiMZ1RYsrWJ1DOb0aJNR82MINUsQmoSkxccZ8NxBYRiJJY
	+6mfEaSIWWAvo8SsH6vAdggJrGSUWNmp1MXIwcEpECzRu1ALxBQWcJF49wZsGQvQmHfLl7OA
	hHkFbCWe/lIACfMKCEr8mHyPBcRmFtCSWL/zOBOELS+xec1bZpByCQF1iUd/dSEOMJK4/aWN
	DaJERGLfi3dgx0gIfGWX6H14iQ1ilYDEt8mHWCB6ZSU2HWCGeFdS4uCKGywTgM5GsnkWks2z
	kGyehWTFAkaWVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBsXv637P+HYx3D1gfYkwGWj+R
	WUo0OR8Y+3kl8YbGZkYWpiamxkbmlmakCSuJ895/mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJ
	g1OqgXHZct7WOSfSUnZ1JHWLvbu7kPWs0sM35xQ95r4LW9IqO1vP+MnGg7OlOG47eNt1dYrM
	EnXqPHTWw61xQoPHlCeKGRdrjr3ZXmXcfeVLRXA7d2dD7A+hg+xxKcl/59oG/Fly+6VXxJ0l
	f15WZHcFnXCua7KPllhltvjkNTOfkGsSB79nh1aZtCuxFGckGmoxFxUnAgC7qhIp8wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQV3dhtYgg/6b5hbNi9ezWVx42sNm
	caLvA6vF5V1z2CxmnN/HZHHq+mc2i8Nv2lkd2D32z13D7nHlRBOrR9+WVYwex29sZ/L4vEku
	gDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+gO
	JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPG7hNrmAoW8VYs2/+AqYHx
	OlcXIyeHhICJRNuu1SwQtpjEhXvr2boYuTiEBKYzSkzZ+oQFwvnNKLHmwwZmkCo2AVWJiSvu
	s4HYIgJREms/9TOCFDEL7GWUmPVjFStIQkhgJaPEyk6lLkYODk6BYInehVogprCAi8S7N+wg
	FSxAY94tX84CEuYVsJV4+ksBJMwrICjxY/I9sHuYBbQk1u88zgRhy0tsXvOWGaRcQkBd4tFf
	XYgDjCRuf2ljgygRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhb
	XJqXrpecn7uJEZwYnkntYFzZYHGIUYCDUYmHN0K6NUiINbGsuDL3EKMEB7OSCO+zBKAQb0pi
	ZVVqUX58UWlOavEhxmSgPycyS4km5wOTVl5JvKGxiZmRpZG5oYWRsTlpwkrivAdarQOFBNIT
	S1KzU1MLUotgtjBxcEo1MAY5NJ5Vdnfqnn7hYjVPQEUZ2xN2YZ6pXFuVpk0+UBxj/35X13su
	i+avJhO3OUyPX/yMe/qE7oQl85MMNQMnnDxb8DPog/pB7YQkNuEPBqUBLw7VTu549Znr8hqJ
	VzOD/l64X3pqT6F5iOfb4kk7bs/IXGr3sGveq58LI9i1Hr12OHBJd2oww0MlluKMREMt5qLi
	RABlN8lgUAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

> -----Original Message-----
> From: Olof Johansson [mailto:olof@lixom.net]
> Sent: Friday, November 15, 2013 10:49 AM
> To: Greg Kroah-Hartman
> Cc: Kishon Vijay Abraham I; linux-fbdev@vger.kernel.org; linux-samsung-
> soc@vger.kernel.org; linux-kernel@vger.kernel.org; Sylwester Nawrocki;
> InKi Dae
> Subject: Re: [PATCH] video: exynos_mipi_dsim: Remove unused variable
> 
> On Thu, Nov 14, 2013 at 5:32 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Nov 14, 2013 at 01:09:24PM -0800, Olof Johansson wrote:
> >> commit 7e0be9f9f7cba3356f75b86737dbe3a005da067e ('video:
> exynos_mipi_dsim:
> >> Use the generic PHY driver') resulted in a warning about an unused
> >> variable:
> >>
> >> drivers/video/exynos/exynos_mipi_dsi.c:144:26: warning: unused variable
> >>     'pdev' [-Wunused-variable]
> >>
> >> It is indeed unused; remove it.
> >>
> >> Signed-off-by: Olof Johansson <olof@lixom.net>
> >> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> ---
> >>  drivers/video/exynos/exynos_mipi_dsi.c |    1 -
> >>  1 file changed, 1 deletion(-)
> >
> > I had to take the offending patch through my tree due to the phy
> > changes, but I'm not the maintainer of it, nor the video mantainer, so I
> > can't really take this patch through my trees, sorry.
> 
> I was wondering why you had signed off, since it didn't follow the
> regular path. Makes sense.
> 
> So, looks like most historical patches to this file have gone through
> Andrew. Can I get an ack from someone and just take it through arm-soc
> in this case, please? Inki?
> 

Acked-by: Inki Dae <inki.dae@samsung.com>

Thanks,
Inki Dae

> 
> -Olof

