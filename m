Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967768Ab3E3HOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:14:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43587 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967668Ab3E3HO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:14:26 -0400
Message-ID: <1369898064.22004.134.camel@joe-AO722>
Subject: Re: [PATCH] powerpc/pseries: use 'true' instead of '1' for
 orderly_poweroff
From: Joe Perches <joe@perches.com>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Thu, 30 May 2013 00:14:24 -0700
In-Reply-To: <1369897651-23770-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1369897651-23770-1-git-send-email-lig.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-30 at 15:07 +0800, liguang wrote:
> orderly_poweroff is expecting a bool parameter, so
> use 'ture' instead '1'
[]
> diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
[]
> @@ -162,7 +162,7 @@ void rtas_parse_epow_errlog(struct rtas_error_log *log)
>  
>  	case EPOW_SYSTEM_HALT:
>  		pr_emerg("Firmware initiated power off");
> -		orderly_poweroff(1);
> +		orderly_poweroff(ture);
>  		break;

Compile your patches _before_ submitting them please.

"true" not "ture" here and in the commit message.

