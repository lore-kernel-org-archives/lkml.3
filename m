Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3BDSop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:44:45 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:51881 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3BDSoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:44:44 -0500
Date: Mon, 4 Feb 2013 19:44:36 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] config: fix make kvmconfig
Message-ID: <20130204184436.GA13256@gmail.com>
References: <1356040315.3198.51.camel@shinybook.infradead.org>
 <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org>
 <alpine.DEB.2.00.1212252222450.24528@chino.kir.corp.google.com>
 <1356564746.7010.56.camel@shinybook.infradead.org>
 <50DB9FA5.6070704@infradead.org>
 <alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

>  arch/x86/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 6979498..f9459b3 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -606,6 +606,7 @@ config KVMTOOL_TEST_ENABLE
>  	select NETWORK_FILESYSTEMS
>  	select INET
>  	select EXPERIMENTAL
> +	select TTY
>  	select SERIAL_8250
>  	select SERIAL_8250_CONSOLE
>  	select IP_PNP

There's no 'config TTY' in the kernel AFAICS.

Did you mean:

	select SERIAL_CORE
	select SERIAL_CORE_CONSOLE

?

Thanks,

	Ingo
