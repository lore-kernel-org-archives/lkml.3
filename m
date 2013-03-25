Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab3CYKQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:16:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64740 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab3CYKQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:16:43 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-2a-5150240a1357
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Axel Lin'" <axel.lin@ingics.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>, linux-kernel@vger.kernel.org
References: <1363407672.3898.1.camel@phoenix>
In-reply-to: <1363407672.3898.1.camel@phoenix>
Subject: RE: [PATCH RESEND] gpio: samsung: Add terminating entry for
 exynos_pinctrl_ids
Date: Mon, 25 Mar 2013 19:16:41 +0900
Message-id: <177a01ce2941$d843d420$88cb7c60$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4h/cB6BNz7yRGwStO3KBF4cAXV5QHQ1DxA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zfV0ulYBAg08/mC2OzPnKbPHqzEY2
	iyl/ljNZXN41h81i/YzXLBbHZixhdGDzaPtZ5nHn2h42j74tqxg9fr7U8fi8SS6ANYrLJiU1
	J7MstUjfLoEr4+LbRYwF9zkqPq2bzNjAOJG9i5GTQ0LAROLg2p1sELaYxIV764FsLg4hgWWM
	ErsPvwByOMCK3r+Dik9nlPhybBMrSIOQwF9GiYbTkiA2m4CGxOH3z9hBikQEGhgljj1cygKS
	YBYokbjecp8JokFXYv7r02BxTgE9iYmdW1hAFggLRErMn18LYrIIqEpM+uMJYvIK2ErcuScH
	UswrICjxY/I9sGJmAXWJKVNyIWbLS2xe85YZ4kh1iUd/dUHCIgJGEi3d6xghSkQk9r14xwhy
	l4TAI3aJA40bwPazCAhIfJt8iAWiV1Zi0wFmSCBIShxccYNlAqPELCSLZyEsnoVk8SwkGxYw
	sqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECInSiTsY7x+wPsSYDLR9IrOUaHI+MMrzSuIN
	jc2MLExNTI2NzC3NSBNWEudVb7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDI78InurFu
	T8R7SU/mhWJ/Zz5cvqvv3wz1nPQfIXnX1zhqlq/jP/E9jFns4O+8+jcmurwpUatrw+vuNpRN
	2ndL9pbkvb/VfSsuXzwkrqBhyD5pvrB9V+welsXX5L1ey/EaCAjKVO56duXnX9vJEd+yp3bt
	cs15mjE7o3xigaTp/96KbDbzRc+UWIozEg21mIuKEwFqZveH6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQV1OlYBAg+1nbCyOzPnKbPHqzEY2
	iyl/ljNZXN41h81i/YzXLBbHZixhdGDzaPtZ5nHn2h42j74tqxg9fr7U8fi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bFt4sYC+5zVHxaN5mxgXEiexcjB4eE
	gInE+3dsXYycQKaYxIV764FsLg4hgemMEl+ObWIFSQgJ/GWUaDgtCWKzCWhIHH7/jB2kSESg
	gVHi2MOlLCAJZoESiest95kgGnQl5r8+DRbnFNCTmNi5hQVkmbBApMT8+bUgJouAqsSkP54g
	Jq+ArcSde3IgxbwCghI/Jt8DK2YWUJeYMiUXYra8xOY1b5khDlaXePRXFyQsImAk0dK9jhGi
	RERi34t3jBMYhWYhGTQLYdAsJINmIelYwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4
	BTyT2sG4ssHiEKMAB6MSD69AjX+gEGtiWXFl7iFGCQ5mJRFeLaGAQCHelMTKqtSi/Pii0pzU
	4kOMyUBPTmSWEk3OB6anvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFs
	YeLglGpgbOZb9TJh4dr+b+K8O1/MfJPD9TOpdka/2cz8Axt9As6yxsVVR5lusimOLwzRrMg9
	HOJ8/PQzZ9YVovze7SHiB7hMPuVl1kx4/qC/NlODteXA1Tc/11nWMgrM9/+0cBMXf67Mn+93
	Ld6wLhMqPhfb45+ekZi58ozyxP9Cd7bbCc9ffH3TnI8vlViKMxINtZiLihMBpgoIoUUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> 
> The of_device_id table is supposed to be zero-terminated.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

I think, would be better if this could be sent to upstream via gpio tree now.

Thanks.

- Kukjin

> ---
> This patch was sent on https://lkml.org/lkml/2012/12/9/135
> Re-generate the patch against linux-next and resend.
> 
>  drivers/gpio/gpio-samsung.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> index 99e0fa4..b22ca79 100644
> --- a/drivers/gpio/gpio-samsung.c
> +++ b/drivers/gpio/gpio-samsung.c
> @@ -3030,6 +3030,7 @@ static __init int samsung_gpiolib_init(void)
>  		{ .compatible = "samsung,exynos4x12-pinctrl", },
>  		{ .compatible = "samsung,exynos5250-pinctrl", },
>  		{ .compatible = "samsung,exynos5440-pinctrl", },
> +		{ }
>  	};
>  	for_each_matching_node(pctrl_np, exynos_pinctrl_ids)
>  		if (pctrl_np && of_device_is_available(pctrl_np))
> --
> 1.7.9.5

