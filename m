Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3BYXzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:55:47 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44215 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3BYXzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:55:44 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <512BF9DA.2050906@jp.fujitsu.com>
Date: Tue, 26 Feb 2013 08:55:06 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-efi@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH] x86, efi: Mark disable_runtime as __initdata
References: <1361545427-26393-1-git-send-email-matt@console-pimps.org>
In-Reply-To: <1361545427-26393-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/02/23 0:03), Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> disable_runtime is only referenced from __init functions, so mark it
> as __initdata.
> 
> Reported-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>

It looks good to me.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>  arch/x86/platform/efi/efi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 2f81db4..5ae99f9 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -85,7 +85,7 @@ int efi_enabled(int facility)
>  }
>  EXPORT_SYMBOL(efi_enabled);
>  
> -static bool disable_runtime = false;
> +static bool __initdata disable_runtime = false;
>  static int __init setup_noefi(char *arg)
>  {
>  	disable_runtime = true;
> 


