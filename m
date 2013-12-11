Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab3LKNri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:47:38 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:51647 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3LKNrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:47:36 -0500
Message-ID: <1386769650.22397.27.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH] security: ima: new helper: file_inode(file)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Date: Wed, 11 Dec 2013 08:47:30 -0500
In-Reply-To: <52A80210.7060907@huawei.com>
References: <52A80210.7060907@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121113-8236-0000-0000-000004C9CF72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 14:11 +0800, Libo Chen wrote: 
> Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>

Thanks!

Mimi

> ---
>  security/integrity/ima/ima_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index c38bbce..6d76d4a 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -132,7 +132,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
>  		       const char *op, const char *cause)
>  {
>  	struct ima_template_entry *entry;
> -	struct inode *inode = file->f_dentry->d_inode;
> +	struct inode *inode = file_inode(file);
>  	int violation = 1;
>  	int result;
> 


