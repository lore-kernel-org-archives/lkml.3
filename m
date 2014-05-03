Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaECOcN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 10:32:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:49319 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaECOcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 10:32:12 -0400
Message-ID: <5364FDE3.6050306@infradead.org>
Date: Sat, 03 May 2014 07:32:03 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Udo Seidel <udoseidel@gmx.de>
Subject: Re: [RFC 05/16] kgr: update Kconfig documentation
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz> <1398868249-26169-6-git-send-email-jslaby@suse.cz>
In-Reply-To: <1398868249-26169-6-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 07:30 AM, Jiri Slaby wrote:
> This is based on Udo's text which were augmented in this patch.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Udo Seidel <udoseidel@gmx.de>
> Cc: Vojtech Pavlik <vojtech@suse.cz>
> ---
>   kernel/Kconfig.kgr | 3 +++
>   samples/Kconfig    | 4 ++++
>   2 files changed, 7 insertions(+)
>
> diff --git a/kernel/Kconfig.kgr b/kernel/Kconfig.kgr
> index af9125f27b6d..f66fa2c20656 100644
> --- a/kernel/Kconfig.kgr
> +++ b/kernel/Kconfig.kgr
> @@ -5,3 +5,6 @@ config KGR
>   	tristate "Kgr infrastructure"
>   	depends on DYNAMIC_FTRACE_WITH_REGS
>   	depends on HAVE_KGR
> +	help
> +	 Select this to enable kGraft online kernel patching. The
> +	 runtime price is zero, so it is safe to say Y here.

Please indent help text 2 spaces instead of 1 to be consistent and to
follow CodingStyle.

Also, I would prefer that this feature be referred to as kgraft (with
any capital letters that you prefer) instead of kgr.
kgr is too meaningless to me.

> diff --git a/samples/Kconfig b/samples/Kconfig
> index a923510443de..29eba4b77812 100644
> --- a/samples/Kconfig
> +++ b/samples/Kconfig
> @@ -58,6 +58,10 @@ config SAMPLE_KDB
>   config SAMPLE_KGR_PATCHER
>   	tristate "Build kgr patcher example -- loadable modules only"
>   	depends on KGR && m
> +	help
> +	 Sample code to replace sys_iopl() and sys_capable() via
> +	 kGraft. This is only for presentation purposes. It is safe to
> +	 say Y here.
>
>   config SAMPLE_RPMSG_CLIENT
>   	tristate "Build rpmsg client sample -- loadable modules only"
>


-- 
~Randy
