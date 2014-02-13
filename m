Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbaBMJuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:50:32 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:64853 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbaBMJua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:50:30 -0500
Message-ID: <1392285028.30853.24.camel@x220>
Subject: Re: [PATCH] Blackfin: remove "config IP_CHECKSUM_L1"
From: Paul Bolle <pebolle@tiscali.nl>
To: Steven Miao <realmz6@gmail.com>
Cc: adi-buildroot-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Thu, 13 Feb 2014 10:50:28 +0100
In-Reply-To: <1363899006.1390.157.camel@x61.thuisdomein>
References: <1363899006.1390.157.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2014 09:50:28.0568 (UTC) FILETIME=[06C87580:01CF28A1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Replaced previous maintainer and list with current maintainer and
list.]

On Thu, 2013-03-21 at 21:50 +0100, Paul Bolle wrote:
> The only user of Kconfig symbol IP_CHECKSUM_L1 got removed in v2.6.33,
> with commit ddf9ddacef0989fdeb22e182212a232488f0f3ad ("Blackfin: convert
> to generic checksum code"). We can remove the Kconfig entry for this
> unused symbol now.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Has someone ever looked at this trivial patch? The Kconfig entry for
this symbol is still present in v3.14-rc2.

> Untested.
> 
>  arch/blackfin/Kconfig | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
> index c3f2e0b..a8acb1d 100644
> --- a/arch/blackfin/Kconfig
> +++ b/arch/blackfin/Kconfig
> @@ -866,14 +866,6 @@ config SYS_BFIN_SPINLOCK_L1
>  	  If enabled, sys_bfin_spinlock function is linked
>  	  into L1 instruction memory. (less latency)
>  
> -config IP_CHECKSUM_L1
> -	bool "Locate IP Checksum function in L1 Memory"
> -	default n
> -	depends on !SMP
> -	help
> -	  If enabled, the IP Checksum function is linked
> -	  into L1 instruction memory. (less latency)
> -
>  config CACHELINE_ALIGNED_L1
>  	bool "Locate cacheline_aligned data to L1 Data Memory"
>  	default y if !BF54x


Paul Bolle

