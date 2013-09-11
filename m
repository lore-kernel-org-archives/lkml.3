Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab3IKEaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52537 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab3IKE37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:59 -0400
X-AuditID: cbfee68e-b7f756d000004512-cd-522ff1c0a5f0
Message-id: <522FF1C0.7020509@samsung.com>
Date: Wed, 11 Sep 2013 13:29:52 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        "'Anish Kumar'" <anish198519851985@gmail.com>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Mike Lockwood'" <lockwood@android.com>,
        "'Laxman Dewangan'" <ldewangan@nvidia.com>,
        "'Graeme Gregory'" <gg@slimlogic.co.uk>
Subject: Re: [PATCH V2] extcon: use dev_get_platdata()
References: <004201ceae9c$42c82ff0$c8588fd0$%han@samsung.com>
In-reply-to: <004201ceae9c$42c82ff0$c8588fd0$%han@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkUPfAR/0gg6tHzS0u3+hitujf4mJx
	eeElVoslk+ezWizdt5rF4vKuOWwW/x5tY7e43biCzYHDY9vubaweO2fdZfdY8uYQq0dv8zs2
	j74tqxg9pk75y+jxeZNcAHsUl01Kak5mWWqRvl0CV8ab569YCn6xVBy77d3A+IG5i5GTQ0LA
	ROLXlY9sELaYxIV764FsLg4hgaWMEkf33mTvYuQAK3p/lhEiPp1R4snzQ+wQzitGifsLV4F1
	8wpoSRyfep0RxGYRUJXo+f8ebAMbUHz/ixtgNaICYRIrp19hgagXlPgx+R6YLSKgIvF5/XGw
	zcwCC5kkFqy9DpYQFjCTmHjoF5gtJGArcXb/J0aQizgF7CRmXHYECTML6Ejsb53GBmHLS2xe
	85YZZI6EwCN2iQ0TL7FAHCQg8W3yIRaIb2QlNh2A+l5S4uCKGywTGMVmITlpFpKxs5CMXcDI
	vIpRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjMCJP/3vWt4Px5gHrQ4zJQCsnMkuJJucDIzqv
	JN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYy2G/gP
	ny53O1V+qkLQva3TvpnVNXXbIwdGTTlv/bX+yp+Ez1z8UXVqY1C7ZMj8fplLf3lcIhf5pOqU
	GR7hu8jhVsmwx8tb6Lyv/a4jR97t0WfVfX8qQjnJ6YKVloac3F/Pzg+zrN0+Wm17vVajzdVc
	MJkjfd0b46rql7d0TY4dWdptWD7vkhJLcUaioRZzUXEiAEK6YxneAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd0DH/WDDNr/6FtcvtHFbNG/xcXi
	8sJLrBZLJs9ntVi6bzWLxeVdc9gs/j3axm5xu3EFmwOHx7bd21g9ds66y+6x5M0hVo/e5nds
	Hn1bVjF6TJ3yl9Hj8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ
	b56/Yin4xVJx7LZ3A+MH5i5GDg4JAROJ92cZuxg5gUwxiQv31rN1MXJxCAlMZ5R48vwQO4Tz
	ilHi/sJVbCBVvAJaEsenXgfrYBFQlej5/54ZxGYDiu9/cQOsRlQgTGLl9CssEPWCEj8m3wOz
	RQRUJD6vPw62gVlgIZPEgrXXwRLCAmYSEw/9ArOFBGwlzu7/xAhyHaeAncSMy44gYWYBHYn9
	rdPYIGx5ic1r3jJPYBSYhWTFLCRls5CULWBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kR
	HO/PpHcwrmqwOMQowMGoxMN7Q04/SIg1say4MvcQowQHs5II71QnoBBvSmJlVWpRfnxRaU5q
	8SHGZGAITGSWEk3OB6aivJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJpCeWpGanphakFsFs
	YeLglGpgXFzRcmVyxXx2szmdH3QudOXpmYsxVIlXLLZtlN3M2t5lHXR4bbenzSyRh1K567qU
	zJ7GyTyfVrZboKVvwl+nkl9ROdEzbMMCZFf3ndx8XLYyur6rPVlq5+vnoWyZbxWLDfNFRdgK
	GUJC8nQ/Nmjx/D7/4kJY7R3Nw+eOqDtzyobdOiuxw1aJpTgj0VCLuag4EQActrdmOwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 12:08 PM, Jingoo Han wrote:
> Use the wrapper function for retrieving the platform data instead of
> accessing dev->platform_data directly. This is a cosmetic change
> to make the code simpler and enhance the readability.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Changes since v2:
> - squashed 3 patches into a single patch
> 
>  drivers/extcon/extcon-adc-jack.c |    2 +-
>  drivers/extcon/extcon-gpio.c     |    2 +-
>  drivers/extcon/extcon-palmas.c   |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 

Applied it on extcon-linus branch.

Thanks,
Chanwoo Choi

