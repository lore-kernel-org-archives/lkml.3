Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaH3K6j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 06:58:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35119 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaH3K6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 06:58:37 -0400
Date: Sat, 30 Aug 2014 13:58:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Janet Liu <jianhua.ljh@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv1 1/4] staging:lustre:lnet: lib-md.c make line not over
 80 characters
Message-ID: <20140830105819.GH5071@mwanda>
References: <1409381575-2211-1-git-send-email-jianhua.ljh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409381575-2211-1-git-send-email-jianhua.ljh@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 02:52:55PM +0800, Janet Liu wrote:
> @@ -121,7 +123,7 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
>  
>  		lmd->md_length = total_length;
>  
> -		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /* max size used */
> +		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /*max size used*/

Better to go over the 80 character limit than to mangle it this way.

regards,
dan carpenter

