Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161541Ab3DGDSF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 23:18:05 -0400
Received: from intranet.asianux.com ([58.214.24.6]:41801 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161342Ab3DGDSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 23:18:01 -0400
X-Spam-Score: -100.8
Message-ID: <5160E549.4080702@asianux.com>
Date: Sun, 07 Apr 2013 11:17:29 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: JBottomley@parallels.com, Greg KH <gregkh@linuxfoundation.org>,
        kxie@chelsio.com, michaelc@cs.wisc.edu
CC: linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/scsi/cxgbi: using ccflags-y instead of EXTRA_CFLAGS
 in Kbuild
References: <50F15A35.4000400@asianux.com> <50FB9A33.2090204@asianux.com> <51077BB3.2010809@asianux.com> <512ECDDC.2020607@asianux.com> <512EF43D.1070805@asianux.com> <512EFA91.5050101@asianux.com>
In-Reply-To: <512EFA91.5050101@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

  please help check it when you have time.

  thanks.

gchen.

On 2013Äê02ÔÂ28ÈÕ 14:34, Chen Gang wrote:
> 
>   need using ccflags-y instead of EXTRA_CFLAGS
>     can reference scripts/checkpatch.pl (1755..1766)
> 
>   when make EXTRA_CFLAGS=-W, the compiling issue will be occured.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  drivers/scsi/cxgbi/cxgb3i/Kbuild |    2 +-
>  drivers/scsi/cxgbi/cxgb4i/Kbuild |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/cxgbi/cxgb3i/Kbuild b/drivers/scsi/cxgbi/cxgb3i/Kbuild
> index 6f095e2..961a12f 100644
> --- a/drivers/scsi/cxgbi/cxgb3i/Kbuild
> +++ b/drivers/scsi/cxgbi/cxgb3i/Kbuild
> @@ -1,3 +1,3 @@
> -EXTRA_CFLAGS += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb3
> +ccflags-y += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb3
>  
>  obj-$(CONFIG_SCSI_CXGB3_ISCSI) += cxgb3i.o
> diff --git a/drivers/scsi/cxgbi/cxgb4i/Kbuild b/drivers/scsi/cxgbi/cxgb4i/Kbuild
> index 8290cda..3745864 100644
> --- a/drivers/scsi/cxgbi/cxgb4i/Kbuild
> +++ b/drivers/scsi/cxgbi/cxgb4i/Kbuild
> @@ -1,3 +1,3 @@
> -EXTRA_CFLAGS += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb4
> +ccflags-y += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb4
>  
>  obj-$(CONFIG_SCSI_CXGB4_ISCSI) += cxgb4i.o
> 


-- 
Chen Gang

Asianux Corporation
