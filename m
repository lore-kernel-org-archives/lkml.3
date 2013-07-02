Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab3GBBOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 21:14:35 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:27822 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab3GBBOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 21:14:34 -0400
Message-ID: <51D2295E.8010601@huawei.com>
Date: Tue, 2 Jul 2013 09:14:06 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Forest Bond <forest@alittletooquiet.net>,
        Jiri Kosina <trivial@kernel.org>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Devendra Naga <devendra.aaru@gmail.com>, Joe Perches <joe@perches.com>,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: Re: [PATCH 4/6] vt6655/trivial: replace numeric with standard PM
 state macros
References: <1372337843-24624-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1372337843-24624-1-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping...?

On 2013/6/27 20:57, Yijing Wang wrote:
> Use standard PM state macros PCI_Dx instead of numeric 0/1/2..
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Forest Bond <forest@alittletooquiet.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Kosina <trivial@kernel.org>
> Cc: Devendra Naga <devendra.aaru@gmail.com>
> Cc :Joe Perches <joe@perches.com>
> Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
> Cc: Bill Pemberton <wfp5p@virginia.edu>
> Cc: devel@driverdev.osuosl.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/staging/vt6655/device_main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
> index 08b250f..7f36a71 100644
> --- a/drivers/staging/vt6655/device_main.c
> +++ b/drivers/staging/vt6655/device_main.c
> @@ -3370,8 +3370,8 @@ viawget_resume(struct pci_dev *pcid)
>  	PSMgmtObject  pMgmt = pDevice->pMgmt;
>  	int power_status;   // to silence the compiler
>  
> -	power_status = pci_set_power_state(pcid, 0);
> -	power_status = pci_enable_wake(pcid, 0, 0);
> +	power_status = pci_set_power_state(pcid, PCI_D0);
> +	power_status = pci_enable_wake(pcid, PCI_D0, 0);
>  	pci_restore_state(pcid);
>  	if (netif_running(pDevice->dev)) {
>  		spin_lock_irq(&pDevice->lock);
> 


-- 
Thanks!
Yijing

