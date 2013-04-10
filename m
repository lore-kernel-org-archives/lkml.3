Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936887Ab3DJKbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:31:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8530 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936140Ab3DJKbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:31:31 -0400
X-AuditID: cbfee68d-b7f786d000005188-78-51653f8146df
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, balbi@ti.com, rob.herring@calxeda.com,
        thomas.abraham@linaro.org, grant.likely@secretlab.ca,
        dianders@chromium.org, jg1.han@samsung.com, p.paneri@samsung.com
References: <1363334171-21812-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1363334171-21812-1-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v4 0/2] ARM: Exynos5250: Enabling samsung usb phy
Date: Wed, 10 Apr 2013 19:31:29 +0900
Message-id: <310001ce35d6$901546b0$b03fd410$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4hUtjhrvxLxxXmRTOUAM4gSYJATQUg0EpA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+ZgW6jfWqgQd8EfYuD9+stXh7StDgw
	+yGrxdllB9ks2q4cZLd4dWYjm8XlhZdYLS7vmsNmMeP8PiaLRctamS3Ob+lksji84gCTxbEZ
	SxgdeD0WfL7C7jG74SKLx51re9g8zs9YyOjRt2UVo8fPlzoex29sZ/L4vEkugCOKyyYlNSez
	LLVI3y6BK+P83APMBffZKnpWpjYwbmXtYuTkkBAwkfhzZRc7hC0mceHeerYuRi4OIYFljBL3
	7x1ghym6c+YeVGI6o8ThK1dYIJy/jBJTvx9iA6liE9CQOPz+GViHiMAkRokTawVAbGaBw4wS
	S/7WgthCAh4SdzpWMoPYnAKeEhOXvmMBsYUFXCV+bzgJ1ssioCpxrfM+I4jNK2ArsXFZAzOE
	LSjxY/I9FoiZWhLrdx5ngrDlJTaveQtUwwF0qbrEo7+6ECcYSWxb8QKqRERi34t3jCA3Swgs
	5ZB49usMI8QuAYlvkw+xQPTKSmw6wAzxsKTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyi
	qQXJBcVJ6UWGesWJucWleel6yfm5mxghCaF3B+PtA9aHGJOB1k9klhJNzgcmlLySeENjMyML
	UxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MPqYOzdtWTsrYEuQ
	32Gri4lnphXbHZwZPKEz+uolz2tdf+cvk5lxuDu2+qbO47alKtLhJVfk1KL37DRInmv8JSJr
	UUeP/Mbcowd2zW3lVDGoCfYKURO4yN4UWZf43O5L/ZSfm56mpiyUSsmW2D+7YrXdpjat4/9E
	LfVTVSNvMnmx364R09r1RImlOCPRUIu5qDgRAHJOLmgeAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsVy+t9jQd1G+9RAg6stWhYH79dbvDykaXFg
	9kNWi7PLDrJZtF05yG7x6sxGNovLCy+xWlzeNYfNYsb5fUwWi5a1Mluc39LJZHF4xQEmi2Mz
	ljA68Hos+HyF3WN2w0UWjzvX9rB5nJ+xkNGjb8sqRo+fL3U8jt/YzuTxeZNcAEdUA6NNRmpi
	SmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDFSgpliTmlQKGA
	xOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaM83MPMBfcZ6voWZnawLiVtYuRk0NCwETi
	zpl7bBC2mMSFe+uBbC4OIYHpjBKHr1xhgXD+MkpM/X4IrIpNQEPi8Ptn7CC2iMAkRokTawVA
	bGaBw4wSS/7WgthCAh4SdzpWMoPYnAKeEhOXvmMBsYUFXCV+bzgJ1ssioCpxrfM+I4jNK2Ar
	sXFZAzOELSjxY/I9FoiZWhLrdx5ngrDlJTaveQtUwwF0qbrEo7+6ECcYSWxb8QKqRERi34t3
	jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwunkmvYNx
	VYPFIUYBDkYlHt4FhimBQqyJZcWVuYcYJTiYlUR4LbRSA4V4UxIrq1KL8uOLSnNSiw8xJgM9
	OpFZSjQ5H5gK80riDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB
	0fnKf+Xoz5tloyfp1BZ7prLtzdyxaYvTiwVS85qtFnzbMMlG4apw5+T38vzC1qs+bxBM/hg0
	3brznbz59UY/H924l6Hq7alH1atuOUU7JHts1s/quT9pulLtJr7whAtpl87ftk5Riel7qLx5
	PcP25lkFa8O3Hrmw9sGdtjT+LuNXKbKz/TZGKrEUZyQaajEXFScCAO1v3oN7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Gautam wrote:
> 
> Based on 'for-next' of linux-samsung tree with following patches
> from Doug on top:
> usb: Document clocks in samsung, exynos4210-ehci/ohci bindings
> ARM: dts: add usb 2.0 clock references to exynos5250 device tree
> 
> Also depending upon following patch-series for Samsung-usb-phy driver:
> [PATCH v7 0/2] Adding USB 3.0 DRD-phy support for exynos5250
> 
> Changes from v3:
> Added 'clocks' and 'clock-names' entry also in device nodes, aligning
> with common clock framework for Samsung's SoCs.
> 
> Vivek Gautam (2):
>   ARM: Exynos5250: Enabling samsung-usb2phy driver
>   ARM: Exynos5250: Enabling samsung-usb3phy driver
> 
>  arch/arm/boot/dts/exynos5250.dtsi |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
> --
> 1.7.6.5

OK, applied, thanks.

- Kukjin

