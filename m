Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab3HGENv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 00:13:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29857 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3HGENo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 00:13:44 -0400
X-AuditID: cbfee691-b7fef6d000002d62-45-5201c976e59b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH V5] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
Date: Wed, 07 Aug 2013 13:13:42 +0900
Message-id: <002501ce9324$8066f5a0$8134e0e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6TJHzb0/LWXiwVREuX4otx/hBlbg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t8zI92yk4xBBjf2ylr8nXSM3WJJU4bF
	y0OaFvOPnGO1uLzwEqtF74KrbBYXnvawWVzeNYfN4uy842wWM87vY7LYOPUXo0X7JWWLn7vm
	sVg0Hn3AatH65AGjA7/H71+TGD12zrrL7rFgU6nH94Xz2T36tqxi9Hj6Yy+zx/Eb25k8Pm+S
	C+CI4rJJSc3JLEst0rdL4Mr4ev8be8FFroq5fysbGBs5uhg5OSQETCQWbVnEDGGLSVy4t56t
	i5GLQ0hgGaPE8xtLmWGK9v1ZwwyRWMQo0fHjPSuE84tR4tyLtywgVWwCahJfvhxmB7FFBDQl
	Zq/YwgRSxCzwnlli9apFYAlhgUSJiYu/MIHYLAKqEht2HQKL8wpYSpx++pgJwhaU+DH5HthQ
	ZgEtifU7jzNB2PISm9e8hTpJQWLH2deMEMv0JGY/OMoMUSMise/FO0aQxRICMzkkTpy+wwyx
	TEDi2+RDQEM5gBKyEpsOQM2RlDi44gbLBEaxWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9
	yFSvODG3uDQvXS85P3cTIyTuJ+5gvH/A+hBjMtD6icxSosn5wLSRVxJvaGxmZGFqYmpsZG5p
	Rpqwkjiveot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZG93TuV8uN5zdWLlzPtoZJ/qdj
	4eP74gdLCppn9pVKqU9lYYh4835FpWGHRM3Nj+J2mxZtjJdTa1c+f5Jb9evJdbP1jTUnfbFx
	WVH+3+3Vu1/L0rZV9uiwr3DZu5m/PqN69j6BjQu6K7Kan557p/5AmWXqq/BvXx8eOW4RvsXs
	w3lvmZ7uOfGpSizFGYmGWsxFxYkAyOb3AhEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t9jAd2yk4xBBs8+iVv8nXSM3WJJU4bF
	y0OaFvOPnGO1uLzwEqtF74KrbBYXnvawWVzeNYfN4uy842wWM87vY7LYOPUXo0X7JWWLn7vm
	sVg0Hn3AatH65AGjA7/H71+TGD12zrrL7rFgU6nH94Xz2T36tqxi9Hj6Yy+zx/Eb25k8Pm+S
	C+CIamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6
	XUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8fX+N/aCi1wVc/9WNjA2
	cnQxcnJICJhI7PuzhhnCFpO4cG89WxcjF4eQwCJGiY4f71khnF+MEudevGUBqWITUJP48uUw
	O4gtIqApMXvFFiaQImaB98wSq1ctAksICyRKTFz8hQnEZhFQldiw6xBYnFfAUuL008dMELag
	xI/J98CGMgtoSazfeZwJwpaX2LzmLdRJChI7zr5mhFimJzH7wVFmiBoRiX0v3jFOYBSYhWTU
	LCSjZiEZNQtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwUnlmdQOxpUNFocYBTgY
	lXh4K8QYg4RYE8uKK3MPMUpwMCuJ8GrNAQrxpiRWVqUW5ccXleakFh9iTAb6dCKzlGhyPjDh
	5ZXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDI6/5hsCcnh7f
	2DmdbRvPP3V2nHJjNStv+31b/r+SDiwf9Cvymaf9eMj+QTfvZqjEju8iX0K780X26nYZXFx6
	3mr7wR3WFnLXvHI3xzqt1bT8k/Cp5d/pRdqq4ov+dvnLBdqwWvZYbrAzKl7x4IHHYUbu7QUa
	nzmvm1x8NWOXvLWsae6HNf/vKrEUZyQaajEXFScCACgOXTFuAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 31, 2013 5:14 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> Exynos PCIe IP consists of Synopsys specific part and Exynos
> specific part. Only core block is a Synopsys designware part;
> other parts are Exynos specific.
> Also, the Synopsys designware part can be shared with other
> platforms; thus, it can be split two parts such as Synopsys
> designware part and Exynos specific part.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Pratyush Anand <pratyush.anand@st.com>
> Cc: Mohit KUMAR <Mohit.KUMAR@st.com>

Hi Bjorn Helgaas,

There is no comment for last 2 weeks.
Will you accept this patch?


Best regards,
Jingoo Han

> ---
> Changes since v4:
> - fixed section mismatch warnings
> - fixed sparse warnings
> 
>  .../devicetree/bindings/pci/designware-pcie.txt    |    3 +
>  arch/arm/boot/dts/exynos5440.dtsi                  |    2 +
>  drivers/pci/host/Makefile                          |    3 +-
>  drivers/pci/host/pci-exynos.c                      |  530 ++++++++++
>  drivers/pci/host/pcie-designware.c                 | 1011 ++++++--------------
>  drivers/pci/host/pcie-designware.h                 |   65 ++
>  6 files changed, 874 insertions(+), 740 deletions(-)
>  create mode 100644 drivers/pci/host/pci-exynos.c
>  create mode 100644 drivers/pci/host/pcie-designware.h


