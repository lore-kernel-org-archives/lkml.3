Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3KTGUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 01:20:32 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50287 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab3KTGU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 01:20:29 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-0a-528c54ac5df7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Stefan Kristiansson'" <stefan.kristiansson@saunalahti.fi>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1384920820-18740-1-git-send-email-stefan.kristiansson@saunalahti.fi>
In-reply-to: <1384920820-18740-1-git-send-email-stefan.kristiansson@saunalahti.fi>
Subject: Re: [PATCH v2] video: add OpenCores VGA/LCD framebuffer driver
Date: Wed, 20 Nov 2013 15:20:28 +0900
Message-id: <000701cee5b8$9b61e3b0$d225ab10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7lpwGh9XGrKhRaTyWQetxQMl8vVAAEIQLQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zfd01IT1BBrsnKVhcXniJ1eJE3wdW
	i8u75rBZrHv4gsni7KaVTBbr599ic2DzeHXhDotH35ZVjB4Hp3SzeRy/sZ3J4/MmuQDWKC6b
	lNSczLLUIn27BK6MR5svMxfc5K3Y3XCVrYGxn7uLkZNDQsBEYtrKJawQtpjEhXvr2UBsIYFl
	jBIXHjh1MXKA1ayby9nFyAUUXsQocabrGxuE84tRomnWZxaQBjYBNYkvXw6zg9giArYS65Ys
	YgYpYhY4yyixeutuFpBJQgLBEh3rQkFqOAVCJDaeO8EMYgsLuEu8O9IO1ssioCqx6tZGRhCb
	F2jOrAUd7BC2oMSPyffAdjELaEms33mcCcKWl9i85i0zxKHqEo/+6kKcYCRx+cVndogSEYl9
	L94xgpwjIfCSXeL1yz4WiF0CEt8mH2KB6JWV2HSAGRIOkhIHV9xgmcAoMQvJ5llINs9CsnkW
	khULGFlWMYqmFiQXFCelF5noFSfmFpfmpesl5+duYoRE7IQdjPcOWB9iTAZaP5FZSjQ5Hxjx
	eSXxhsZmRhamJqbGRuaWZqQJK4nzqj1KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA6BaU
	6/REac1flc3nnl/OfP15Lc9TjfoSqYsT7HoEFsxrmHfyiMaaNhHjeULyiZ033NaliUwW3qu6
	P4ftfur7k80mx95krszKfsOze01c9l4fLsdpbD3bX8wr/vnySPfrOdMWVpt/t1sdu1Pvufhp
	mfi5W8PDapqUJrZcfP3Ez6mlVl8yb9JjYSWW4oxEQy3mouJEAKrmiADuAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jAd01IT1BBqt7ZSwuL7zEanGi7wOr
	xeVdc9gs1j18wWRxdtNKJov182+xObB5vLpwh8Wjb8sqRo+DU7rZPI7f2M7k8XmTXABrVAOj
	TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QCUoKZYk5
	pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjEebLzMX3OSt2N1wla2BsZ+7i5GD
	Q0LARGLdXM4uRk4gU0ziwr31bF2MXBxCAosYJc50fYNyfjFKNM36zAJSxSagJvHly2F2EFtE
	wFZi3ZJFzCBFzAJnGSVWb93NAjJVSCBYomNdKEgNp0CIxMZzJ5hBbGEBd4l3R9rBelkEVCVW
	3drICGLzAs2ZtaCDHcIWlPgx+R7YLmYBLYn1O48zQdjyEpvXvGWGOFpd4tFfXYgTjCQuv/jM
	DlEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cT
	IzghPJPewbiqweIQowAHoxIPb8Gi7iAh1sSy4srcQ4wSHMxKIry33HuChHhTEiurUovy44tK
	c1KLDzEmAz06kVlKNDkfmKzySuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBa
	BLOFiYNTqoFx0cILfX0f59ptfFIpqSRkpny3QOg7c/ydrxv2L0/Uc9Etep2sZq8UJ7FFiHPl
	/rVTrrsu+H3C41+WyuWLPElyP/qM9cz2fT62ouSlysV2FfdSyeX3r9Zr7ncv+3mb90XHgvk3
	/37/Kb2SN362qnlnz7rooo17Pvza7Nn3gHP9pXuZd7xus6k/VGIpzkg01GIuKk4EAOLP0bFM	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 20, 2013 1:14 PM, Stefan Kristiansson wrote:
> 
> This adds support for the VGA/LCD core available from OpenCores:
> http://opencores.org/project,vga_lcd
> 
> The driver have been tested together with both OpenRISC and
> ARM (socfpga) processors.
> 
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> ---
> Changes in v2:
> - Add Microblaze as an example user and fix a typo in Xilinx Zynq
> ---
>  drivers/video/Kconfig  |  17 ++
>  drivers/video/Makefile |   1 +
>  drivers/video/ocfb.c   | 479 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 497 insertions(+)
>  create mode 100644 drivers/video/ocfb.c
> 

Hi Stefan Kristiansson,

I added trivial comments as below.

[.....]

> --- /dev/null
> +++ b/drivers/video/ocfb.c

[.....]

> +static int ocfb_probe(struct platform_device *pdev)
> +{
> +	int ret = 0;
> +	struct ocfb_dev *fbdev;
> +	struct ocfb_par *par = &ocfb_par_priv;
> +	struct resource *res;
> +	struct resource *mmio;
> +	int fbsize;
> +
> +	fbdev = kzalloc(sizeof(*fbdev), GFP_KERNEL);

Please use devm_kzalloc() instead of kzalloc().
In this case, kfree() can be removed from ocfb_probe()
and ocfb_remove(). Thus, it will make the code smaller.

[.....]

> +
> +#ifdef MODULE

I don't think that '#ifdef MODULE' is necessary.
Is there any reason?

Best regards,
Jingoo Han

> +MODULE_AUTHOR("Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>");
> +MODULE_DESCRIPTION("OpenCores VGA/LCD 2.0 frame buffer driver");
> +MODULE_LICENSE("GPL v2");
> +module_param(mode_option, charp, 0);
> +MODULE_PARM_DESC(mode_option, "Video mode ('<xres>x<yres>[-<bpp>][@refresh]')");
> +#endif
> --
> 1.8.3.2

