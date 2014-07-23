Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141AbaGWS3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:29:05 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40809 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584AbaGWS3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:29:03 -0400
Date: Thu, 24 Jul 2014 02:28:57 +0800
From: WANG Chao <wangchao19890207@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: android: ion: fix missing a blank line after
 declarations
Message-ID: <20140723182857.GA31683@dhcp-17-37.nay.redhat.com>
References: <1406140014-22803-1-git-send-email-wangchao19890207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406140014-22803-1-git-send-email-wangchao19890207@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/14 at 02:26am, WANG Chao wrote:
> Fix checkpatch warning of missing a blank line after declarations,
> found under drivers/staging/android/ion/.

Sorry I forgot to mention this is for linux-next.

> 
> Signed-off-by: WANG Chao <wangchao19890207@gmail.com>
> ---
>  drivers/staging/android/ion/ion.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> index 2703609..cad76ae 100644
> --- a/drivers/staging/android/ion/ion.c
> +++ b/drivers/staging/android/ion/ion.c
> @@ -805,6 +805,7 @@ struct ion_client *ion_client_create(struct ion_device *dev,
>  						client, &debug_client_fops);
>  	if (!client->debug_root) {
>  		char buf[256], *path;
> +
>  		path = dentry_path(dev->clients_debug_root, buf, 256);
>  		pr_err("Failed to create client debugfs at %s/%s\n",
>  			path, client->display_name);
> -- 
> 1.9.3
> 
