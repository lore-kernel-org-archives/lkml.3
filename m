Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaINKyP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 06:54:15 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:58464 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaINKyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 06:54:14 -0400
Message-ID: <541573DB.50204@gmail.com>
Date: Sun, 14 Sep 2014 18:54:19 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        David Vrabel <david.vrabel@citrix.com>,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] drivers/xen/xenbus/xenbus_client.c: Remove redundancy
 asignment to 'addr'
References: <54157282.40402@gmail.com> <541572BD.3040101@gmail.com>
In-Reply-To: <541572BD.3040101@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Oh, sorry, for subject, need use 'assignment' instead of 'asignment'.


On 09/14/2014 06:49 PM, Chen Gang wrote:
> When failure occurs, 'node' is already set to NULL, and it is enough
> for next checking (which will return in time), so need not set 'addr'.
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/xen/xenbus/xenbus_client.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
> index 439c9dc..277e74d 100644
> --- a/drivers/xen/xenbus/xenbus_client.c
> +++ b/drivers/xen/xenbus/xenbus_client.c
> @@ -636,7 +636,7 @@ static int xenbus_unmap_ring_vfree_hvm(struct xenbus_device *dev, void *vaddr)
>  			goto found;
>  		}
>  	}
> -	node = addr = NULL;
> +	node = NULL;
>   found:
>  	spin_unlock(&xenbus_valloc_lock);
>  
> 


-- 
Chen Gang

Open share and attitude like air water and life which God blessed
