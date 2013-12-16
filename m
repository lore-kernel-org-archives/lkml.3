Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab3LPKGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:06:24 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:65321 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3LPKGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:06:23 -0500
X-AuditID: cbfee690-b7f206d000000aee-85-52aed09d439a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Wei Yongjun'" <weiyj.lk@gmail.com>, gregkh@linuxfoundation.org,
        eli.billauer@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <CAPgLHd_jJ-gR0CWZKuWUVALXhE9c9a3b+-GspKE_AXKvFW6qPQ@mail.gmail.com>
In-reply-to: <CAPgLHd_jJ-gR0CWZKuWUVALXhE9c9a3b+-GspKE_AXKvFW6qPQ@mail.gmail.com>
Subject: Re: [PATCH -next] staging: xillybus: fix error return code in
 xilly_probe()
Date: Mon, 16 Dec 2013 19:06:20 +0900
Message-id: <000601cefa46$780f81e0$682e85a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac76ItiYBn6qzlb5QMSLX5seYqzUjAAI1Deg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zY925F9YFGez+zmGx58wvdov+vkWM
	Fs2L17NZXF54idXi8q45bBYfLh1ltti5rpPdgd3j3r7DLB47Z91l99g/dw27R9+WVYweS+8d
	ZfT4vEkugC2KyyYlNSezLLVI3y6BK+PqinmsBe/YKz53PGVtYNzE1sXIySEhYCIxbepMVghb
	TOLCvfVAcS4OIYFljBJ7PzWzwxT9fLaFHSKxiFFi04wnjBDOL0aJpe9eM4JUsQmoSXz5chis
	Q0QgRuLa/z4WkCJmgUZGiT3LT4PtExIIkDhz6DNQEQcHp0CwxMv9SiBhYYEwif0dW1lAbBYB
	VYnJZ++CzeEVsJWYu/QGC4QtKPFj8j0wm1lAS2L9zuNMELa8xOY1b5lBRkoIqEs8+qsLcYKR
	xK51O6FKRCT2vXgHdrOEwFd2iZXPr7ND7BKQ+Db5EAtEr6zEpgPMEA9LShxccYNlAqPELCSb
	ZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKJXnJhbXJqXrpecn7uJERLJE3Yw3jtgfYgxGWj9
	RGYp0eR8YCLIK4k3NDYzsjA1MTU2Mrc0I01YSZxX7VFSkJBAemJJanZqakFqUXxRaU5q8SFG
	Jg5OqQbGTsej+xw5Fn2XUT7MumOCQvWRheXT23JOOK4Se/Ou+VbluXXCK6bExX5tcVsSKcNl
	+TxZVnVXlHLRr4NbA/pMe3wath3dtfezKLfN0YOVrvX1SveirJ9fiPnyxvOQldSbDQtWbHuj
	Lzs1/b14cOj5ynsuBhq96qtOucb/zow943ePOUZ8sSSHEktxRqKhFnNRcSIAzgbBX/oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jAd25F9YFGRz4wmKx58wvdov+vkWM
	Fs2L17NZXF54idXi8q45bBYfLh1ltti5rpPdgd3j3r7DLB47Z91l99g/dw27R9+WVYweS+8d
	ZfT4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA
	1y0zB+gYJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPG1RXzWAvesVd8
	7njK2sC4ia2LkZNDQsBE4uezLewQtpjEhXvrgeJcHEICixglNs14wgjh/GKUWPruNSNIFZuA
	msSXL4fBOkQEYiSu/e9jASliFmhklNiz/DTYWCGBAIkzhz4DFXFwcAoES7zcrwQSFhYIk9jf
	sZUFxGYRUJWYfPYu2BxeAVuJuUtvsEDYghI/Jt8Ds5kFtCTW7zzOBGHLS2xe85YZZKSEgLrE
	o7+6ECcYSexatxOqRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFi
	bnFpXrpecn7uJkZwmngmtYNxZYPFIUYBDkYlHl4Fy3VBQqyJZcWVuYcYJTiYlUR4648DhXhT
	EiurUovy44tKc1KLDzEmAz06kVlKNDkfmMLySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQ
	nliSmp2aWpBaBLOFiYNTqoGx8duTWQVsFoUr2j59L/dL11J6pCwRxcXbprtM8uGERH9P3d9T
	Virl7fzPIpLyuJj3qLl3DdPK1C8tazozl3FsOvXmaW3+cp5Xe4WM+j+r9U7fOP/0+es5fLcX
	JYqUzjywxWnt/qpZz5zCPHy8/mk8nJ/I/nnn/AvR82W3pFduP7Bp08Z5Hi5blViKMxINtZiL
	ihMBQNwxUFcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 16, 2013 2:51 PM, Wei Yongjun wrote:
> 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return negative error code -EIO from the error handling
> case instead of 0.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/staging/xillybus/xillybus_pcie.c | 2 +-

It looks good.
Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/xillybus/xillybus_pcie.c b/drivers/staging/xillybus/xillybus_pcie.c
> index 0564f97..51426d8 100644
> --- a/drivers/staging/xillybus/xillybus_pcie.c
> +++ b/drivers/staging/xillybus/xillybus_pcie.c
> @@ -168,9 +168,9 @@ static int xilly_probe(struct pci_dev *pdev,
>  	}
> 
>  	endpoint->registers = pci_iomap(pdev, 0, 128);
> -
>  	if (!endpoint->registers) {
>  		dev_err(endpoint->dev, "Failed to map BAR 0. Aborting.\n");
> +		rc = -EIO;
>  		goto failed_iomap0;
>  	}
> 

