Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbaEGIm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:42:27 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:28962 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbaEGImW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:42:22 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fae6d000004d6d-28-5369f1e9ed66
Content-transfer-encoding: 8BIT
Message-id: <1399452150.15392.1.camel@AMDC1943>
Subject: Re: [PATCH 2/5] regulator: max8952: Make of_device_id array const
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 07 May 2014 10:42:30 +0200
In-reply-to: <01ec01cf69cb$430ae9e0$c920bda0$%han@samsung.com>
References: <01e101cf69c9$abd91f70$038b5e50$%han@samsung.com>
 <01ec01cf69cb$430ae9e0$c920bda0$%han@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t/xa7ovP2YGG5xbYWUx9eETNovLCy+x
	Wny70sFkcXnXHDYHFo+ds+6ye2xa1cnm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmNTQ8Y
	C86zVTQv6GRvYFzH2sXIySEhYCLxaPMkZghbTOLCvfVsXYxcHEICSxkl5j09BJbgFRCU+DH5
	HksXIwcHs4C8xJFL2SBhZgF1iUnzFjFD1H9mlLj7fA4TRL2+xJRpK5hA6oUFvCSafwmAhNkE
	jCU2L1/CBmKLCKhIfF5/nA1iZI7E9dNGIGEWAVWJrqUP2UFsTgE7iY9zDzOC2EIChRJNjz9B
	nawsMW//MaYJjAKzkBw3C+G4WUiOW8DIvIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJGy/
	7mBceszqEKMAB6MSD+8CmYxgIdbEsuLK3EOMEhzMSiK8uy5mBgvxpiRWVqUW5ccXleakFh9i
	ZOLglGpgdPYqfG3iFKZR4dydoDPzF++L68rPE27+470Qcr+y5dq8bY++v9cp/eH99eSix7K2
	rCKbHipUmk64+Gb/0dXqc1Vfbp61bukadr1yh/NWai+uhlu9nNqu3P9d+rtjbv7P7L4uTx9e
	z8B1R6QPP2H9eHla3JnJ7RZHY3juy9QVxb9/8UTk/CQJEyWW4oxEQy3mouJEAESs8a85AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-05-07 at 17:06 +0900, Jingoo Han wrote:
> Make of_device_id array const, because all OF functions
> handle it as const.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/regulator/max8952.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


> 
> diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
> index d920f5a..c2792f0 100644
> --- a/drivers/regulator/max8952.c
> +++ b/drivers/regulator/max8952.c
> @@ -129,7 +129,7 @@ static const struct regulator_desc regulator = {
>  };
>  
>  #ifdef CONFIG_OF
> -static struct of_device_id max8952_dt_match[] = {
> +static const struct of_device_id max8952_dt_match[] = {
>  	{ .compatible = "maxim,max8952" },
>  	{},
>  };

