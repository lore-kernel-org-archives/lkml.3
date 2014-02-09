Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaBIUoM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:44:12 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:59261 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbaBIUoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:44:11 -0500
Message-ID: <1391978649.25855.33.camel@x220>
Subject: Re: [PATCH 18/28] Remove MN10300_PROC_MN2WS0038
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "moderated list:PANASONIC MN10300..." <linux-am33-list@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 21:44:09 +0100
In-Reply-To: <1391971686-9517-19-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-19-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 20:44:10.0207 (UTC) FILETIME=[AF0C9EF0:01CF25D7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: Paul Bolle <pebolle@tiscali.nl>

> ---
>  arch/mn10300/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
> index a648de1..4434b54 100644
> --- a/arch/mn10300/Kconfig
> +++ b/arch/mn10300/Kconfig
> @@ -181,7 +181,7 @@ endmenu
>  config SMP
>  	bool "Symmetric multi-processing support"
>  	default y
> -	depends on MN10300_PROC_MN2WS0038 || MN10300_PROC_MN2WS0050
> +	depends on MN10300_PROC_MN2WS0050
>  	---help---
>  	  This enables support for systems with more than one CPU. If you have
>  	  a system with only one CPU, say N. If you have a system with more

I tried this one too in 2013: https://lkml.org/lkml/2013/5/15/144 .


Paul Bolle

