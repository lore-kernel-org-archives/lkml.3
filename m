Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbaJNVxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:53:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbaJNVxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:53:06 -0400
Date: Tue, 14 Oct 2014 17:52:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: WANG Chao <chaowang@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/x86/purgatory/Makefile: supress kexec-purgatory.c
 is up to date message
Message-ID: <20141014215253.GM5127@redhat.com>
References: <1413262019-3759-1-git-send-email-chaowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413262019-3759-1-git-send-email-chaowang@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 12:46:58PM +0800, WANG Chao wrote:
> Supress this unnecessary message during kernel re-build
> (CONFIG_KEXEC_FILE=y):
> 
> make[1]: `arch/x86/purgatory/kexec-purgatory.c' is up to date.
> 
> Signed-off-by: WANG Chao <chaowang@redhat.com>
> ---
>  arch/x86/purgatory/Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> index f52e033..2c835e3 100644
> --- a/arch/x86/purgatory/Makefile
> +++ b/arch/x86/purgatory/Makefile
> @@ -24,6 +24,7 @@ quiet_cmd_bin2c = BIN2C   $@
>  
>  $(obj)/kexec-purgatory.c: $(obj)/purgatory.ro FORCE
>  	$(call if_changed,bin2c)
> +	@:

Where can I find the description of "@:" and how does it work?

Thanks
Vivek
