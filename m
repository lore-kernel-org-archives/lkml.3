Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaH2RZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:25:34 -0400
Received: from smtp103.biz.mail.gq1.yahoo.com ([98.137.12.178]:28097 "EHLO
	smtp103.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753378AbaH2RZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:25:33 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2014 13:25:33 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: JS9.YK8VM1kd0uRZeTXf64fShJQjoPDOwSbCZ0c7.L4O3Oq
 0VK99JMhcFtBFXPMCbUYJOTNP0pm0vO1I_IhbwKXizpLJW7mU50qUjmH8gno
 dYj817Qp8R482PQSXYYK.zYTdsShqUfToIdXAepY629PAc4qq7OIHDGM_4u6
 J1g0SG04tzVeblPzdg84a5POVsk3UNb6M9CgvBRZKRyFL2uvMpvWmZ1PlcCr
 oOzZmnmx7R2rANLR4i3Ta0JuWFHsDr.utOTvNcdtl6ac8wGfyDO4bHU9Prn2
 pG5AO.tIV1U11sdYcA8zdPT3QZ1MwBkX_pgA36tOAGBgObDz99frspUrawTs
 Uk5_I1N5UDLEwUhUSMFvOVFPKXTNEFziK2oL94XWeCT4iz0OZc.3J7wCN_UF
 SGJYGHeboeo3hB3XRGEg_qwtf5VUgZnB8O.jVqZ0t3aZuyx2oS4clNjJRGrR
 u6Lf5Qjy.9.IKJEdZATxz85GX3_hM3MxF9dDc3mTXrjwlQdmtXZO4j56vuzc
 2_uroy8MJM6D602GaQsE9YW5RHNz76RNm3vXOj1oMseD65zjdEMRuOJ8Kmek
 bi2TZhJqT7pq.bmbMyJu75mJdveUMKJeb1m2k5HEjKTQ5btBVCsGyn4vTbXO
 tiucjVZ54e4U-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <5400B608.1070507@schaufler-ca.com>
Date: Fri, 29 Aug 2014 10:19:04 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lukasz Pawelczyk <l.pawelczyk@samsung.com>, r.krypa@samsung.com,
        havner@gmail.com, m.lis@samsung.com,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
CC: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 1/3] Small fixes in comments describing function parameters
References: <1409324575-12057-1-git-send-email-l.pawelczyk@samsung.com>
In-Reply-To: <1409324575-12057-1-git-send-email-l.pawelczyk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/2014 8:02 AM, Lukasz Pawelczyk wrote:
> Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>

Applied to git://git.gitorious.org/smack-next/kernel.git#smack-for-3.18

> ---
>  security/smack/smack_lsm.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 154548e..478d99e 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -771,8 +771,8 @@ static void smack_inode_free_security(struct inode *inode)
>  
>  /**
>   * smack_inode_init_security - copy out the smack from an inode
> - * @inode: the inode
> - * @dir: unused
> + * @inode: the newly created inode
> + * @dir: containing directory object
>   * @qstr: unused
>   * @name: where to put the attribute name
>   * @value: where to put the attribute value
> @@ -923,10 +923,10 @@ static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
>  
>  /**
>   * smack_inode_rename - Smack check on rename
> - * @old_inode: the old directory
> - * @old_dentry: unused
> - * @new_inode: the new directory
> - * @new_dentry: unused
> + * @old_inode: unused
> + * @old_dentry: the old object
> + * @new_inode: unused
> + * @new_dentry: the new object
>   *
>   * Read and write access is required on both the old and
>   * new directories.
> @@ -1017,7 +1017,7 @@ static int smack_inode_setattr(struct dentry *dentry, struct iattr *iattr)
>  
>  /**
>   * smack_inode_getattr - Smack check for getting attributes
> - * @mnt: unused
> + * @mnt: vfsmount of the object
>   * @dentry: the object
>   *
>   * Returns 0 if access is permitted, an error code otherwise
> @@ -1042,8 +1042,8 @@ static int smack_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
>   * smack_inode_setxattr - Smack check for setting xattrs
>   * @dentry: the object
>   * @name: name of the attribute
> - * @value: unused
> - * @size: unused
> + * @value: value of the attribute
> + * @size: size of the value
>   * @flags: unused
>   *
>   * This protects the Smack attribute explicitly.

