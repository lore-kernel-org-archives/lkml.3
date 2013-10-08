Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab3JHFoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:44:38 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:36243 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3JHFoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:44:34 -0400
Message-ID: <52539BB7.5010207@synopsys.com>
Date: Tue, 8 Oct 2013 11:14:23 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Mark Salter <msalter@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/14] arc: select ARCH_MAY_HAVE_PC_PARPORT
References: <1381209030-351-1-git-send-email-msalter@redhat.com> <1381209030-351-3-git-send-email-msalter@redhat.com>
In-Reply-To: <1381209030-351-3-git-send-email-msalter@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.243]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 10/08/2013 10:40 AM, Mark Salter wrote:
> Architectures which support CONFIG_PARPORT_PC should select
> ARCH_MAY_HAVE_PC_PARPORT.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> CC: Vineet Gupta <vgupta@synopsys.com>
> ---
>  arch/arc/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
> index 91dbb27..484b1a7 100644
> --- a/arch/arc/Kconfig
> +++ b/arch/arc/Kconfig
> @@ -8,6 +8,7 @@
>  
>  config ARC
>  	def_bool y
> +	select ARCH_MAY_HAVE_PC_PARPORT
>  	select CLONE_BACKWARDS
>  	# ARC Busybox based initramfs absolutely relies on DEVTMPFS for /dev
>  	select DEVTMPFS if !INITRAMFS_SOURCE=""
> 


You can drop ARC from the series, we don't care for this deivce.

Thx,
-Vineet
