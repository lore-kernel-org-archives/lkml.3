Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab3EWA1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 20:27:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42918 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab3EWA1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 20:27:41 -0400
X-IronPort-AV: E=Sophos;i="4.87,724,1363104000"; 
   d="scan'208";a="7338935"
Subject: Re: [PATCH] drivers: idle: comment DEBUG
From: li guang <lig.fnst@cn.fujitsu.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1366873227-920-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1366873227-920-1-git-send-email-lig.fnst@cn.fujitsu.com>
Date: Thu, 23 May 2013 08:27:36 +0800
Message-ID: <1369268856.5142.157.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/23 08:26:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/23 08:26:20,
	Serialize complete at 2013/05/23 08:26:20
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping ...

在 2013-04-25四的 15:00 +0800，liguang写道：
> seems we should comment DEBUG as above comment said:
> "/* un-comment DEBUG to enable pr_debug() statements */"
> 
> now, pr_debug is already enabled as DEBUG been defined.
> 
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---
>  drivers/idle/intel_idle.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 5d66750..9618586 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -51,7 +51,7 @@
>   */
>  
>  /* un-comment DEBUG to enable pr_debug() statements */
> -#define DEBUG
> +/* #define DEBUG */
>  
>  #include <linux/kernel.h>
>  #include <linux/cpuidle.h>


