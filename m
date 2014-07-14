Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbaGNWvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:51:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47429 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757251AbaGNWvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:51:01 -0400
Message-ID: <53C45EBE.90301@zytor.com>
Date: Mon, 14 Jul 2014 15:50:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>
CC: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 06/38] x86: clean-up Kbuild file - drop unused assignments
References: <20140714150609.GA28358@ravnborg.org> <1405350546-28467-1-git-send-email-sam@ravnborg.org> <1405350546-28467-6-git-send-email-sam@ravnborg.org>
In-Reply-To: <1405350546-28467-6-git-send-email-sam@ravnborg.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 08:08 AM, Sam Ravnborg wrote:
> Drop unused assignment in Kbuild file.
> The unistd* files are exported using the Kbuild file in uapi/*
> and the assignments in this file was left-overs from the past.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: David Howells <dhowells@redhat.com>
> ---
>  arch/x86/include/asm/Kbuild | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
> index 3ca9762..3221167 100644
> --- a/arch/x86/include/asm/Kbuild
> +++ b/arch/x86/include/asm/Kbuild
> @@ -1,9 +1,3 @@
> -
> -
> -genhdr-y += unistd_32.h
> -genhdr-y += unistd_64.h
> -genhdr-y += unistd_x32.h
> -
>  generic-y += clkdev.h
>  generic-y += early_ioremap.h
>  generic-y += cputime.h
> 

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

