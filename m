Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaBITrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 14:47:03 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:49234 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbaBITrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 14:47:01 -0500
Message-ID: <1391975219.25855.8.camel@x220>
Subject: Re: [PATCH 27/28] Remove ARC_HAS_COH_RTSC
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Vineet Gupta <vgupta@synopsys.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 20:46:59 +0100
In-Reply-To: <1391971686-9517-28-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-28-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 19:47:00.0379 (UTC) FILETIME=[B2B666B0:01CF25CF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:48 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: Paul Bolle <pebolle@tiscali.nl>

This Kconfig symbol was removed in commit 7d087a54aed ("ARC: [SMP]
Disallow RTSC"), merged in v3.13.

> ---
>  arch/arc/plat-arcfpga/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
> index 295cefe..33058aa 100644
> --- a/arch/arc/plat-arcfpga/Kconfig
> +++ b/arch/arc/plat-arcfpga/Kconfig
> @@ -33,7 +33,6 @@ config ISS_SMP_EXTN
>  	bool "ARC SMP Extensions (ISS Models only)"
>  	default n
>  	depends on SMP
> -	select ARC_HAS_COH_RTSC
>  	help
>  	  SMP Extensions to ARC700, in a "simulation only" Model, supported in
>  	  ARC ISS (Instruction Set Simulator).


