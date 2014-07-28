Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaG1LSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:18:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13526 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaG1LSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:18:05 -0400
X-AuditID: cbfee691-b7f306d000003d81-69-53d6316a1d29
Message-id: <53D6316A.2010007@samsung.com>
Date: Mon, 28 Jul 2014 20:18:02 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, jic23@kernel.org,
        devicetree@vger.kernel.org, kgene.kim@samsung.com,
        linux-doc@vger.kernel.org, linux-iio@vger.kernel.org,
        t.figa@samsung.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
        ch.naveen@samsung.com
Subject: Re: [PATCH 2/2] iio: adc: exynos_adc: Add support for S3C24xx ADC
References: <1405995074-3271-1-git-send-email-cw00.choi@samsung.com>
 <1405995074-3271-3-git-send-email-cw00.choi@samsung.com>
 <5954793.q4YDWmuNDB@wuerfel>
In-reply-to: <5954793.q4YDWmuNDB@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkRDfL8FqwwZlL8hZ/Jx1jt7j7/DCj
	xfwj51gtHjStYrLoXXCVzeJs0xt2i02Pr7FaLGxbwmIx78g7FovLu+awWcw4v4/JYv2M1ywO
	PB6/f01i9Ni0qpPNY/OSeo++LasYPT5vkgtgjeKySUnNySxLLdK3S+DKmNm6lrHgDXvFm21f
	WRsYN7B1MXJySAiYSLzcspsFwhaTuHBvPVCci0NIYCmjxLa/k5hgik6emMcEkVjEKPF1/U0W
	COc1o8TbXUfA2nkFtCR+fvkF1sEioCoxb+FpsBVsQPH9L26A2aICYRIrp1+BqheU+DH5Hpgt
	IqAoMfXFM2aQocwCm5gk9i25zQiSEBbwkrjYegHqpnmMEv/vf2AHSXAKaEps37UBzGYW0JHY
	3zqNDcKWl9i85i3YJAmBt+wSy+9BnMciICDxbfIhIJsDKCErsekAM8RvkhIHV9xgmcAoNgvJ
	UbOQjJ2FZOwCRuZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGIHRevrfs4k7GO8fsD7EmAy0
	ciKzlGhyPjDa80riDY3NjCxMTUyNjcwtzUgTVhLnTX+UFCQkkJ5YkpqdmlqQWhRfVJqTWnyI
	kYmDU6qBkdvhQyX3O/a5HecCDpltFHktIMxY7T8/63x+7sVbrpMMf8cZXy3+9aq8s3pV4N2P
	dy4ejWu4Lv1L7trHzUF+knXLwhq+2aRMW9tbGfP9//ndgrcy3k6z+n/dIfI368E/WQmOskJ6
	1jvSZpqqXWWbuKWx6Nzx61NmHVb0t9J5eqJ63aUzb5V02pVYijMSDbWYi4oTAXqRN7/sAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xgG6W4bVgg6cPxC3+TjrGbnH3+WFG
	i/lHzrFaPGhaxWTRu+Aqm8XZpjfsFpseX2O1WNi2hMVi3pF3LBaXd81hs5hxfh+TxfoZr1kc
	eDx+/5rE6LFpVSebx+Yl9R59W1YxenzeJBfAGtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxv
	amZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdJ+SQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+Q
	ILgeIwM0kLCGMWNm61rGgjfsFW+2fWVtYNzA1sXIySEhYCJx8sQ8JghbTOLCvfVAcS4OIYFF
	jBJf199kgXBeM0q83XWEBaSKV0BL4ueXX2AdLAKqEvMWngabxAYU3//iBpgtKhAmsXL6Fah6
	QYkfk++B2SICihJTXzxjBhnKLLCJSWLfktuMIAlhAS+Ji60XoFbPY5T4f/8DO0iCU0BTYvuu
	DWA2s4COxP7WaWwQtrzE5jVvmScwCsxCsmQWkrJZSMoWMDKvYhRNLUguKE5KzzXSK07MLS7N
	S9dLzs/dxAhOBc+kdzCuarA4xCjAwajEw2sRfDVYiDWxrLgy9xCjBAezkgjvVP1rwUK8KYmV
	ValF+fFFpTmpxYcYTYFhMJFZSjQ5H5im8kriDY1NzIwsjcwNLYyMzZXEeQ+2WgcKCaQnlqRm
	p6YWpBbB9DFxcEo1MM7dpJvlavtZsm7r+Ylcr9zE848uZA6rmqcSqtQyPYDrVdJ/+d57bpPM
	Z/0V53t+Ieuk541r2iGtx2fVVnuadhV2/f++Ocn3QC//11c214SU3O9+/jyvkkvowavIzqu3
	Mz0/aZ0L8pDWbVxzWvmcee0dff5pzOaFgWeTa/lEbMsrTgkZs/EwKbEUZyQaajEXFScCADVU
	VewbAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 09:59 PM, Arnd Bergmann wrote:
> On Tuesday 22 July 2014 11:11:14 Chanwoo Choi wrote:
>> This patch add support for s3c2410/s3c2416/s3c2440/s3c2443 ADC. The s3c24xx
>> is alomost same as ADCv1. But, There are a little difference as following:
>> - ADCMUX register address to select channel
>> - ADCDAT mask (10bit or 12bit ADC resolution according to SoC version)
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
> 
> While looking at the driver again to see if the touchscreen patch needs
> an update for this, I noticed that the s3c24xx variants don't have the
> ADC_V1_INTCLR and ADC_V1_CLRINTPNDNUP registers, so I assume your patch
> will have to be updated not to acknowledge the interrupts.
> 
> It's possible that writing to the missing registers is harmless though and
> that you don't need that change.

OK, I'll remove the function pointer of clear_irq for s3c24xx.

Best Regards,
Chanwoo Choi

