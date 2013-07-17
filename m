Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab3GQT6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:58:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43150 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab3GQT6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:58:44 -0400
Message-ID: <51E6F73F.3000202@zytor.com>
Date: Wed, 17 Jul 2013 12:57:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, PaX Team <pageexec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86: Make sure IDT is page aligned
References: <20130716183441.GA14232@www.outflux.net> <tip-4df05f361937ee86e5a8c9ead8aeb6a19ea9b7d7@git.kernel.org> <CAE9FiQV86WdgN3+3FOSSTUvNJ6TgH4zbYkWOS7EPPHwO2Rf2TQ@mail.gmail.com>
In-Reply-To: <CAE9FiQV86WdgN3+3FOSSTUvNJ6TgH4zbYkWOS7EPPHwO2Rf2TQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 11:57 AM, Yinghai Lu wrote:
> 
> Hi, Peter,
> 
> Any reason for why following changelog get dropped?
> 
> ---
> v5:
>  - add comments to all IDTs about alignment reasoning, suggested by Linus
> v4:
>  - rework using __page_aligned_bss, suggested by Yinghai LU
>  - move all the other IDT variables as well, suggested by HPA
> v3:
>  - merge 32-bit and 64-bit idt_table definition
> v2:
>  - 32-bit was already aligned
> ---
> 
> That at least would help us to check if you apply the right version.
> 

Procedurally, the changelogs don't belong in commit messages.  I tend to
leave them in if they are particularly illustrative or if the commit
message only makes sense with the additional context, but neither of
those is really ideal.

Technically, because of the --- line which indicates the end of the
commit message.

	-hpa


