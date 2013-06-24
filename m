Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab3FXHNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 03:13:34 -0400
Received: from ozlabs.org ([203.10.76.45]:47752 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab3FXHNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 03:13:33 -0400
From: Michael Neuling <mikey@neuling.org>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, mahesh@linux.vnet.ibm.com, ananth@in.ibm.com
Subject: Re: [PATCH v3] powerpc/pseries: Enable PSTORE in pseries_defconfig
In-reply-to: <20130624064534.16842.3582.stgit@aruna-ThinkPad-T420>
References: <20130624064534.16842.3582.stgit@aruna-ThinkPad-T420>
Comments: In-reply-to Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
   message dated "Mon, 24 Jun 2013 12:23:00 +0530."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Mon, 24 Jun 2013 17:13:27 +1000
Message-ID: <31757.1372058007@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com> wrote:

> Since now we have pstore support for nvram in pseries, enable it
> in the default config. With this config option enabled, pstore
> infra-structure will be used to read/write the messages from/to nvram.
> 
> Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>

Acked-by: Michael Neuling <mikey@neuling.org>

> ---
>  v3:
> 	Move pstore config to right place
>  v2:
> 	Change patch description
> 
>  arch/powerpc/configs/pseries_defconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
> index c4dfbaf..bea8587 100644
> --- a/arch/powerpc/configs/pseries_defconfig
> +++ b/arch/powerpc/configs/pseries_defconfig
> @@ -296,6 +296,7 @@ CONFIG_SQUASHFS=m
>  CONFIG_SQUASHFS_XATTR=y
>  CONFIG_SQUASHFS_LZO=y
>  CONFIG_SQUASHFS_XZ=y
> +CONFIG_PSTORE=y
>  CONFIG_NFS_FS=y
>  CONFIG_NFS_V3_ACL=y
>  CONFIG_NFS_V4=y
> 
