Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaBYWDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:03:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24827 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaBYWDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:03:42 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-92-530d133b8aa0
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <530D134F.5090403@samsung.com>
Date: Wed, 26 Feb 2014 07:03:59 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
To: Felipe Balbi <balbi@ti.com>, chris@printf.net
Cc: jh80.chung@samsung.com, tgih.jun@samsung.com, linux-mmc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: host: dw: fix possible build error
References: <1393340264-22687-1-git-send-email-balbi@ti.com>
In-reply-to: <1393340264-22687-1-git-send-email-balbi@ti.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWyRsSkWNdamDfYoGmatMXB+/UWEy5vZ7S4
	8auN1eLyrjlsFkf+9zNafLh/kdni+NpwB3aPO9f2sHnceLWQyaNvyypGj+M3tjN5fN4kF8Aa
	xWWTkpqTWZZapG+XwJXRN72NvaBVtKK33amB8ZxgFyMHh4SAicSTuUpdjJxAppjEhXvr2boY
	uTiEBJYySuy60s8KkTCRWPLjMyOILSSwiFFi/1kdEJtXQFDix+R7LCA2s4C6xKR5i5ghbBGJ
	/2f/skPY2hLLFr5mhhj6mlGi9eMRJohmLYkFDZvBGlgEVCW6OpeCLWAT0JHY/u04WI2oQJjE
	1BNXwRaICBhKvLvxDGwQs8B6RomJW86DbRAWsJE4/+QhM8R1NhJPOl+CNXAK2Eqs+PCHFaRB
	QuASu8TONRDvsAgISHybfIgF4n1ZiU0HmCG+lJQ4uOIGywRG8VlInpuF5LlZSJ6bheS5BYws
	qxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzECI/T0v2e9OxhvH7A+xJgMtH4is5Rocj4wwvNK
	4g2NzYwsTE1MjY3MLc1IE1YS5016mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVF+bjGD
	hrKbccSLezIstSeePXCZcZLp+DOtrwnXD6o4lUe/O7N7WeVfzui0yeUve9IVnlvstXX6bcki
	IFjmslk8XHCZstdjw82lS1rvmKpw3jvE+bdK8EzaCr+VUn7/u+SWfD423ddpYbPVJa3XRf3f
	jffd27vo8NEdCS1Zfx85Xp7TMa1G1VKJpTgj0VCLuag4EQDWF5AF5gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAV1rYd5gg40XhSwO3q+3mHB5O6PF
	jV9trBaXd81hszjyv5/R4sP9i8wWx9eGO7B73Lm2h83jxquFTB59W1Yxehy/sZ3J4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGfsmlxdsFqmYf7iFtYHxj0AX
	IyeHhICJxJIfnxkhbDGJC/fWs4HYQgKLGCX2n9UBsXkFBCV+TL7H0sXIwcEsIC9x5FI2SJhZ
	QF1i0rxFzF2MXEDlrxklWj8eYYKo15JY0LCZGcRmEVCV6OpcCjafTUBHYvu342A1ogJhElNP
	XGUBsUUEDCXe3XgGNohZYD2jxMQt59lBEsICNhLnnzxkhjjIRuJJ50uwBk4BW4kVH/6wTmAU
	mIXkvlkI981Cct8CRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHR/ExqB+PKBotDjAIc
	jEo8vAEsvMFCrIllxZW5hxglOJiVRHgtvvEEC/GmJFZWpRblxxeV5qQWH2JMBvpuIrOUaHI+
	MNHklcQbGpuYGVkamRtaGBmbkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANj7woz4a9x
	v45MsZbLvLyz1pVZoL/zrnHZI7GEGaXXTsxKbRQ+6TXzzmSm2/aRhRpavQJGGqnML/cL2k6T
	5E9637NRMHfD18VzlIKbzTkmXP+4UUFBa54rn4JyO/O1o24iXZHPlrDuYd3Uf6LY/7ImrxrD
	c/ammBj9970TXhyeH8d5vG/Vp2IlluKMREMt5qLiRACoA87JKgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Felipe.

When you send the patch related with dw_mmc controller, could you use the prefix "mmc: dw_mmc:"?
"mmc: dw_mmc: fix possible build error"

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

Best Regards,
Jaehoon Chung

On 02/25/2014 11:57 PM, Felipe Balbi wrote:
> Fix the following build errors:
> 
> drivers/mmc/host/dw_mmc-k3.c: In function ‘dw_mci_k3_suspend’:
> drivers/mmc/host/dw_mmc-k3.c:58:2: error: implicit declaration of
> 	function ‘dw_mci_suspend’ [-Werror=implicit-function-declaration]
>   ret = dw_mci_suspend(host);
>   ^
> drivers/mmc/host/dw_mmc-k3.c: In function ‘dw_mci_k3_resume’:
> drivers/mmc/host/dw_mmc-k3.c:76:2: error: implicit declaration of
> 	function ‘dw_mci_resume’ [-Werror=implicit-function-declaration]
>   return dw_mci_resume(host);
>   ^
> drivers/mmc/host/dw_mmc-k3.c: At top level:
> drivers/mmc/host/dw_mmc-k3.c:53:12: warning: ‘dw_mci_k3_suspend’ defined
> 	but not used [-Wunused-function]
>  static int dw_mci_k3_suspend(struct device *dev)
>             ^
> drivers/mmc/host/dw_mmc-k3.c:65:12: warning: ‘dw_mci_k3_resume’ defined
> 	but not used [-Wunused-function]
>  static int dw_mci_k3_resume(struct device *dev)
>             ^
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/mmc/host/dw_mmc-k3.c | 2 ++
>  drivers/mmc/host/dw_mmc.h    | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc-k3.c b/drivers/mmc/host/dw_mmc-k3.c
> index f567c21..650f9cc 100644
> --- a/drivers/mmc/host/dw_mmc-k3.c
> +++ b/drivers/mmc/host/dw_mmc-k3.c
> @@ -50,6 +50,7 @@ static int dw_mci_k3_probe(struct platform_device *pdev)
>  	return dw_mci_pltfm_register(pdev, drv_data);
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
>  static int dw_mci_k3_suspend(struct device *dev)
>  {
>  	struct dw_mci *host = dev_get_drvdata(dev);
> @@ -75,6 +76,7 @@ static int dw_mci_k3_resume(struct device *dev)
>  
>  	return dw_mci_resume(host);
>  }
> +#endif /* CONFIG_PM_SLEEP */
>  
>  static SIMPLE_DEV_PM_OPS(dw_mci_k3_pmops, dw_mci_k3_suspend, dw_mci_k3_resume);
>  
> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
> index 6bf24ab..1f7a745 100644
> --- a/drivers/mmc/host/dw_mmc.h
> +++ b/drivers/mmc/host/dw_mmc.h
> @@ -185,7 +185,7 @@
>  
>  extern int dw_mci_probe(struct dw_mci *host);
>  extern void dw_mci_remove(struct dw_mci *host);
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
>  extern int dw_mci_suspend(struct dw_mci *host);
>  extern int dw_mci_resume(struct dw_mci *host);
>  #endif
> 

