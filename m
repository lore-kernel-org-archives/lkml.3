Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaKHJqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 04:46:53 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28443 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbaKHJqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 04:46:49 -0500
X-AuditID: cbfee68d-f79296d000004278-63-545de6862782
From: Kukjin Kim <kgene@kernel.org>
To: "'Javier Martinez Canillas'" <javier@dowhile0.org>
Cc: "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Kevin Hilman'" <khilman@linaro.org>,
        "=?UTF-8?Q?'Andreas_F=C3=A4rber'?=" <afaerber@suse.de>,
        "'Ajay Kumar'" <ajaykumar.rs@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>
References: <1408956336-17376-1-git-send-email-javier.martinez@collabora.co.uk>
 <CABxcv=m-aNVcUU2C8LosCECxq1yZo2C3zfA2xe6z7jF8tFPsnw@mail.gmail.com>
In-reply-to: <CABxcv=m-aNVcUU2C8LosCECxq1yZo2C3zfA2xe6z7jF8tFPsnw@mail.gmail.com>
Subject: RE: [PATCH v2 1/1] ARM: exynos_defconfig: Enable options for display
 panel support
Date: Sat, 08 Nov 2014 18:46:43 +0900
Message-id: <000d01cffb38$e90e42c0$bb2ac840$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGKKDOrcdp1Jl2nMPn0J+5S6jhmlAEyV1wEnNiOdKA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zI922Z7EhBs9aNCyaNxVbHHh/kMXi
	7LKDbBZHfxdYXPs9g83i6+EVjBabHl9jtbi8aw6bxYzz+5gsTl3/zObA5TG74SKLx9/n14HE
	7FZmjzvX9rB5bF5S73HlRBOrR9+WVYwem09Xe3zeJBfAGcVlk5Kak1mWWqRvl8CV8eHPXNaC
	A7wVt/78YmtgvMXVxcjJISFgIvHx5nlWCFtM4sK99WwgtpDAMkaJr29KYGq+Pf/D3MXIBRSf
	ziix8+Q3NgjnL6NE25HDQA4HB5uAskRjkz5Ig7CAlsTCLU0sILYIUPONCQfB6pkFpjBLfO9t
	hpo0jVFi2adPYFWcAsESXz+eYwEZJCwQK3F5WwFImEVAVWLVxTtgJbwCFhJrX1xjgrAFJX5M
	vgcWZxZQl5g0bxEzhC0vsXnNW2aIqxUkdpx9zQhxhJXE2cd7oGpEJPa9eMcIcoOEwFwOiVM/
	P7NBLBOQ+Db5ENgNEgKyEpsOQM2RlDi44gbLBEbJWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmg
	OCm9yFCvODG3uDQvXS85P3cTIyQp9O5gvH3A+hCjAAejEg/vjZbYECHWxLLiytxDjKZAF01k
	lhJNzgemnrySeENjMyMLUxNTYyNzSzMlcV5FqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODil
	GhjbZ4SteDCzaqrhweDXWycu6DK2CbH0VnBIeejhbRlf+feYiq201VajaIZ3De8U09/Ktls1
	rtFflVpoNumet8v6ZsunQXWiuj1fRFR6Les8ZR+s7H774eNS82Nndrb97QtbxP8jRa75nPEa
	vtywz5/OdHxrmV+V0lecp8H8fs8y5s3Wmz6V9yuxFGckGmoxFxUnAgCkNW0rBQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQd22Z7EhBk8XKls0byq2OPD+IIvF
	2WUH2SyO/i6wuPZ7BpvF18MrGC02Pb7GanF51xw2ixnn9zFZnLr+mc2By2N2w0UWj7/PrwOJ
	2a3MHneu7WHz2Lyk3uPKiSZWj74tqxg9Np+u9vi8SS6AM6qB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6EwlhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8aHP3NZCw7wVtz684utgfEWVxcjJ4eEgInEt+d/mCFsMYkL99az
	dTFycQgJTGeU2HnyG5Tzl1Gi7chhIIeDg01AWaKxSR+kQVhAS2LhliYWEFsEaNCNCQfB6pkF
	pjBLfO9tZoZonsYosezTJ7AqToFgia8fz7GADBIWiJW4vK0AJMwioCqx6uIdsBJeAQuJtS+u
	MUHYghI/Jt8DizMLqEtMmreIGcKWl9i85i3U1QoSO86+ZoQ4wkri7OM9UDUiEvtevGOcwCg8
	C8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgpPOM+kdjKsaLA4x
	CnAwKvHw3miJDRFiTSwrrsw9xCjBwawkwtt7HijEm5JYWZValB9fVJqTWnyI0RTo04nMUqLJ
	+cCEmFcSb2hsYmZkaWRmYWRibq4kznuw1TpQSCA9sSQ1OzW1ILUIpo+Jg1OqgTFqj+yEZw9t
	1q3Utpn1bOLqD6/LOgvjxU5onUk5NjtA4N7vgK25CRLrDu39m6AouFmyxsz6qyzr0s/zYu8f
	XfhP7a3RtKkRvxMPqVqdy5qfdlXFZOqvVbHui3f8DRPZy3CyNu2k9a1POlGR/Cx/Dx8PPbvq
	tseesxWbs/hM9oV/Z3ZaLf/RpWCnEktxRqKhFnNRcSIAaz/wCVADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier Martinez Canillas wrote:
> 
> Hello Kukjin,
> 
Hi,

> On Mon, Aug 25, 2014 at 10:45 AM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
> > Many Exynos devices have a display panel. Most of them just have
> > a simple panel while others have more complex configurations that
> > requires an embedded DisplayPort (eDP) to LVDS bridges.
> >
> > This patch enables the following features to be built in the kernel
> > image to suport both setups:
> >
> > - Direct Rendering Manager (DRM)
> > - DRM bridge registration and lookup framework
> > - Parade ps8622/ps8625 eDP/LVDS bridge
> > - NXP ptn3460 eDP/LVDS bridge
> > - Exynos Fully Interactive Mobile Display controller (FIMD)
> > - Panel registration and lookup framework
> > - Simple panels
> > - Backlight & LCD device support
> >
> > Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > Tested-by: Kevin Hilman <khilman@linaro.org>
> > ---
> 
> This patch is needed to have display working on many Exynos boards.
> 
OK, I'll apply this into samsung tree in this weekend.

Thanks for your gentle reminder.

- Kukjin

> $subject enables the config option for the ps8622/ps8625 eDP/LVDS
> bridge driver but this has not landed in mainline yet. Ajay will
> re-spin a new revision of his series that adds this driver though,
> after addressing some issues pointed out on a previous version.
> 
> The Kconfig symbol name (DRM_PS8622) won't change though so maybe is
> not crazy to pick the patch as is since CONFIG_DRM_PS8622 will have to
> be enabled later when the bridge driver lands. Or do you want me to
> re-spin $subject removing that option?
> 
> Best regards,
> Javier

