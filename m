Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaLBIio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:38:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:19602 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaLBIim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:38:42 -0500
X-AuditID: cbfee68e-f79b46d000002b74-b4-547d7a900b05
From: Jingoo Han <jg1.han@samsung.com>
To: "'Javier Martinez Canillas'" <javier@dowhile0.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>
Cc: "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Ajay Kumar'" <ajaykumar.rs@samsung.com>,
        "'Kukjin Kim'" <kgene@kernel.org>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1416807683-2257-1-git-send-email-gautam.vivek@samsung.com>
 <CABxcv=mmJp2c=ZC8=0+TW0-x3g7RnELTAFY24KJRjUgf+QrDcQ@mail.gmail.com>
In-reply-to: <CABxcv=mmJp2c=ZC8=0+TW0-x3g7RnELTAFY24KJRjUgf+QrDcQ@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND] arm: dts: Exynos5: Use pmu_system_controller
 phandle for dp phy
Date: Tue, 02 Dec 2014 17:39:58 +0900
Message-id: <000501d00e0b$8e0e8610$aa2b9230$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAOCGuCuqv5WMb8QvaMHSMrnc/pnAAAhgHA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zA90JVbUhBpPPsVoceH+QxWL+ESDr
	ytf3bBZtVw6yWxz9XWBx7fcMNovLCy+xWvQuuMpm0f/4NbPF5V1z2CxmnN/HZPFz1zwWBx6P
	v8+vs3j8nd3K7LFz1l12j02rOtk87ncfZ/Lo27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujFmP
	djMXzOWtuDH1EksD42muLkYODgkBE4mfP/i6GDmBTDGJC/fWs3UxcnEICSxjlPg6dxEbRMJE
	4vy5t1CJ6YwS97ZsZodwfjFKLOr/yw5SxSagJvHly2GwhIhAO6PE1b8/wFqYBb4wSdy+cw+q
	pY9R4t+VNiaQFk6BYInV95YygtjCAgkS/w4dYgGxWQRUJZZd3wU2llfAVuLMsxVMELagxI/J
	98BqmAXUJSbNW8QMYctLbF7zlhniIXWJR391QUwRASOJnVNFISpEJPa9eMcIcoKEwFwOiaYP
	h1khVglIfJsMshakVVZi0wFmiJclJQ6uuMEygVFiFpLFs5AsnoVk8SwkKxYwsqxiFE0tSC4o
	TkovMtIrTswtLs1L10vOz93ECEkCfTsYbx6wPsQowMGoxMN74nxNiBBrYllxZe4hRlOgiyYy
	S4km5wNTTV5JvKGxmZGFqYmpsZG5pZmSOG+C1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxS
	DYz1yiXMeqzLufZ5zui4WsLb1BAvf7vN3e/0wbWOf3zPsKb72gZs/vLS2HNL3qPaiBsnNgke
	PvpAIXDHyV8zkm6tL3BQr7sev8AkzXj+lTqve6o77jg0Pa/xrO0+frhW2Yvdtt+RNW5tpuJ9
	owlZV+6osi5wrSnwrlx+pfHNo7k3ZtiUrlJ3vq3EUpyRaKjFXFScCAB86WEs/QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd3+qtoQg4mXbCwOvD/IYjH/yDlW
	iytf37NZtF05yG5x9HeBxbXfM9gsLi+8xGrRu+Aqm0X/49fMFpd3zWGzmHF+H5PFz13zWBx4
	PP4+v87i8Xd2K7PHzll32T02repk87jffZzJo2/LKkaPz5vkAtijGhhtMlITU1KLFFLzkvNT
	MvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AuVVIoS8wpBQoFJBYXK+nbYZoQ
	GuKmawHTGKHrGxIE12NkgAYS1jFmzHq0m7lgLm/FjamXWBoYT3N1MXJySAiYSJw/95YNwhaT
	uHBvPZDNxSEkMJ1R4t6WzewQzi9GiUX9f9lBqtgE1CS+fDkMlhARaGeUuPr3B1gLs8AXJonb
	d+5BtfQxSvy70sYE0sIpECyx+t5SRhBbWCBB4t+hQywgNouAqsSy67vAxvIK2EqcebaCCcIW
	lPgx+R5YDbOAusSkeYuYIWx5ic1r3gLZHEDHqks8+qsLYooIGEnsnCoKUSEise/FO8YJjEKz
	kAyahWTQLCSDZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOMk8k97BuKrB4hCj
	AAejEg/vifM1IUKsiWXFlbmHGCU4mJVEeH8Z14YI8aYkVlalFuXHF5XmpBYfYjQF+nMis5Ro
	cj4wAeaVxBsam5gZWRqZWRiZmJsrifPeuJkbIiSQnliSmp2aWpBaBNPHxMEp1cDYzfheK+ul
	8IGg6kuVs9gPi7mVyiYLKhXFrS68eEfrl1nNj50soaeNF76uP5TXt9q17qKYzqc9ISfc/iQ8
	/3FWa+rMI5GRPD8PMrzd5HS4qWrDbc1v5p8fPlVZ55TxQax5wuSyE5nT/uWeFWY/Hrdb6gfH
	iklqlrsObWVTXf7Pqfhh59c7LjacSizFGYmGWsxFxYkAKNBzTkgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 02, 2014 5:17 PM, Javier Martinez Canillas wrote:
> 
> Hello Kukjin,
> 
> On Mon, Nov 24, 2014 at 6:41 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> > DP PHY now require pmu-system-controller to handle PMU register
> > to control PHY's power isolation. Adding the same to dp-phy
> > node.
> >
> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> > Reviewed-by: Jingoo Han <jg1.han@samsung.com>
> > Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > Cc: Kukjin Kim <kgene@kernel.org>
> 
> Any opinions about $subject?
> 
> This patch is -rc material since is needed after commit a5ec598 ("phy:
> exynos-dp-video: Use syscon
> support to control pmu register") which landed in 3.18. That means
> that display for Exynos is currently broken in 3.18.
> 
> I think it's too late for the 3.18 -rc cycle but at least it would be
> great to have this merged for 3.19 and backport to stable kernels to
> have display working again.

I agree with this suggestion.

> 
> Thierry had concerns that this change breaks DT backward compability
> but actually it was already been broken by a5ec598 which changed the
> DT binding for the phy-exynos-dp-video driver so we should either
> apply this patch now or revert a5ec598.

I think that very few people might use old properties for Exynos DP.
Actually, DT backward compatibility will not be the considerable problem
in my opinion.

But, in order to keep the DT backward compatibility, we should revert
a5ec598, and send another patch for keeping the DT backward compatibility.

Best regards,
Jingoo Han

> 
> Thanks a lot and best regards,
> Javier

