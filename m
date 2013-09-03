Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443Ab3ICF6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 01:58:24 -0400
Received: from intranet.asianux.com ([58.214.24.6]:19704 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab3ICF6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 01:58:23 -0400
X-Spam-Score: -100.9
Message-ID: <52257A3E.7040001@asianux.com>
Date: Tue, 03 Sep 2013 13:57:18 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>, Joe Perches <joe@perches.com>,
        "'Jiri Kosina'" <trivial@kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, davej@redhat.com,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH trivial] UAPI: Kbuild: add/modify comments for "uapi/Kbuild"
 and "uapi/linux/Kbuild"
References: <52005571.4080704@asianux.com> <1375810303.2424.28.camel@joe-AO722> <1375860749.8422.25@driftwood> <520209FA.70409@asianux.com> <5202FEC3.4010408@asianux.com> <52145F5C.9090907@asianux.com> <521739B3.9050001@asianux.com>
In-Reply-To: <521739B3.9050001@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Maybe... I still miss some important mail addresses? or this patch is
not suitable for applying?

Hmm... but I still want to try the last time: "please help check this
patch, when you have time".

And next, I should not send additional tracing mail again, that will be
really spam.


Thanks.

On 08/23/2013 06:30 PM, Chen Gang wrote:
> Hello Maintainers:
> 
> Is this patch suitable for applying ?  Does it belong to 'trivial' (or
> 'Documentation', or others) ?
> 
> 
> And sorry for my original missing some important mail addresses when I
> sent the original patch (I got them by "./scripts/get_maintainers", and
> not give more considerations for them).
> 
> So I append my original patch below, if necessary, please help check
> when you have time, thanks.
> 
> 
> ------------------------------patch begin-------------------------------
> 
> "include/uapi/" is the whole Linux kernel API, it is important enough
> to get more global explanations by comments.
> 
> In "include/uapi/Kbuild", "Makefile..." and "non-arch..." comments are
> meaningless for current 'Kbuild', so delete them.
> 
> And add more explanations for "include/uapi/" in "include/uapi/Kbuild",
> also add more explanations for "include/uapi/linux/" in "include/uapi
> /linux/Kbuild".
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  include/uapi/Kbuild       |    5 ++---
>  include/uapi/linux/Kbuild |    2 ++
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/Kbuild b/include/uapi/Kbuild
> index 81d2106..c682891 100644
> --- a/include/uapi/Kbuild
> +++ b/include/uapi/Kbuild
> @@ -1,7 +1,6 @@
>  # UAPI Header export list
> -# Top-level Makefile calls into asm-$(ARCH)
> -# List only non-arch directories below
> -
> +# Except "linux/", UAPI means Universal API.
> +# For "linux/", UAPI means User API which can be used by user mode.
> 
>  header-y += asm-generic/
>  header-y += linux/
> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> index 997f9f2..0025e07 100644
> --- a/include/uapi/linux/Kbuild
> +++ b/include/uapi/linux/Kbuild
> @@ -1,4 +1,6 @@
>  # UAPI Header export list
> +# UAPI is User API which can be used by user mode.
> +
>  header-y += byteorder/
>  header-y += can/
>  header-y += caif/
> 


-- 
Chen Gang
