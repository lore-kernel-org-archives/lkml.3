Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837AbaKMXe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:34:56 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16207 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964804AbaKMXex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:34:53 -0500
X-AuditID: cbfee691-f79b86d000004a5a-ff-5465401ba4fb
Message-id: <5465401A.6060506@samsung.com>
Date: Fri, 14 Nov 2014 08:34:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, lgirdwood@gmail.com, myungjoo.ham@samsung.com,
        linus.walleij@linaro.org, gnurou@gmail.com, broonie@kernel.org,
        tiwai@suse.de, perex@perex.cz, sameo@linux.intel.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-gpio@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 5/6] extcon: arizona: Add support for WM8280/WM8281
References: <1415901046-3391-1-git-send-email-rf@opensource.wolfsonmicro.com>
 <1415901046-3391-6-git-send-email-rf@opensource.wolfsonmicro.com>
In-reply-to: <1415901046-3391-6-git-send-email-rf@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42JZI2JSoivtkBpi8H4uu8WVi4eYLKY+fMJm
	8W/KDXaL+UfOsVr0v1nIanHu1SMWILGS0eL+16OMFt+udDBZTPmznMli8/w/jBaXd81hs1h6
	/SKTxe3GFWwWy9/+Z7OYMH0ti0Xnrn5Wi1kT/7BYtO49wm5xupvV4uXmN0wOoh4bPjexeayZ
	t4bR43JfL5PHzll32T1WLv/C5rFpVSebx51re9g85p0M9Hg58Tebx763y9g8+rasYvTYfLra
	4/MmuQDeKC6blNSczLLUIn27BK6MD09OsRW8ZK2YumcOewPjbZYuRg4OCQETiUs7DbsYOYFM
	MYkL99azdTFycQgJLGWUWNl6mx2mZtfaUoj4dEaJBxOPMEM4rxkltuzrZQbp5hXQktg74R6Y
	zSKgKtFyfx4jiM0GFN//4gYbiC0qECaxcvoVFoh6QYkfk++B2SIC5hKLb95hBbGZBX4yS0z8
	UQtiCwu4S5w7/58dYtlERokJxxaCLeAU8JPYveYfE0SDjsT+1mlsELa8xOY1b8GukxB4wSGx
	seEIG8RFAhLfJh+CellWYtMBZoiXJSUOrrjBMoFRbBaSm2YhGTsLydgFjMyrGEVTC5ILipPS
	i0z1ihNzi0vz0vWS83M3MQKTyel/zybuYLx/wPoQowAHoxIP7wuWlBAh1sSy4srcQ4ymQFdM
	ZJYSTc4Hpqy8knhDYzMjC1MTU2Mjc0szJXFeHemfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4
	pRoYrWymTCqumelr9CvTpPSIxCu//dwPPz3tFOGZlnbDcOelMIeNMqa6ts1P9+dWSGTznxJk
	lZV2tnaZKaC4cnvJhE8fGRru1CXtLpz/pPEe48y1PrcSVLdN2WQp9qf55Cst854t2wK/rHDc
	/fDxByvVKx82n9JfnVLD7TFloVj4i8RPIeJmX9d1KrEUZyQaajEXFScCAEy6k0IhAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jQV0ph9QQg8cd1hZXLh5ispj68Amb
	xb8pN9gt5h85x2rR/2Yhq8W5V49YgMRKRov7X48yWny70sFkMeXPciaLzfP/MFpc3jWHzWLp
	9YtMFrcbV7BZLH/7n81iwvS1LBadu/pZLWZN/MNi0br3CLvF6W5Wi5eb3zA5iHps+NzE5rFm
	3hpGj8t9vUweO2fdZfdYufwLm8emVZ1sHneu7WHzmHcy0OPlxN9sHvveLmPz6NuyitFj8+lq
	j8+b5AJ4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTd
	MnOAXlZSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZnx4coqt4CVrxdQ9
	c9gbGG+zdDFycEgImEjsWlvaxcgJZIpJXLi3nq2LkYtDSGA6o8SDiUeYIZzXjBJb9vUyg1Tx
	CmhJ7J1wD8xmEVCVaLk/jxHEZgOK739xgw3EFhUIk1g5/QoLRL2gxI/J98BsEQFzicU377CC
	2MwCP5klJv6oBbGFBdwlzp3/zw6xbCKjxIRjC8EWcAr4Sexe848JokFHYn/rNDYIW15i85q3
	zBMYBWYh2TELSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQnq2dSOxhXNlgc
	YhTgYFTi4X3BkhIixJpYVlyZe4hRgoNZSYT3kWJqiBBvSmJlVWpRfnxRaU5q8SFGU2AQTGSW
	Ek3OBybSvJJ4Q2MTMyNLI3NDCyNjcyVx3gOt1oFCAumJJanZqakFqUUwfUwcnFINjO0Cpy7J
	Oop8srvVOsX2Qv/Xp3M3msy87vy67ehnA7m4ApP32jOa41cHPu6eVKSvdEj48CcBxq23FR7y
	dD5itd4kq/M8PGt6wZRTNesSzMtePwu4dvDG9EhrWXd9heYQsdf3Ug0ZPzYd8Yzvtbigqbma
	y609oFHEbQPXyo5z84Jfmsa0NItEKbEUZyQaajEXFScCAG8raYdsAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 02:50 AM, Richard Fitzgerald wrote:
> Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index ba51588..3abe866 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -1149,6 +1149,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>  		}
>  		break;
>  	case WM5110:
> +	case WM8280:
>  		switch (arizona->rev) {
>  		case 0 ... 2:
>  			break;
> 

This patch is simple.

Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

Best Regards,
Chanwoo Choi
