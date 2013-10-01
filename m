Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3JACUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 22:20:50 -0400
Received: from intranet.asianux.com ([58.214.24.6]:18534 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab3JACUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 22:20:48 -0400
X-Spam-Score: -100.6
Message-ID: <524A3139.7000905@asianux.com>
Date: Tue, 01 Oct 2013 10:19:37 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>, Joe Perches <joe@perches.com>,
        "'Jiri Kosina'" <trivial@kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, davej@redhat.com,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH trivial v3] include/uapi/Kbuild: modify the comments for
 it
References: <52005571.4080704@asianux.com> <1375810303.2424.28.camel@joe-AO722> <1375860749.8422.25@driftwood> <520209FA.70409@asianux.com> <5202FEC3.4010408@asianux.com> <52145F5C.9090907@asianux.com> <521739B3.9050001@asianux.com> <52257A3E.7040001@asianux.com> <5227D472.1010100@asianux.com> <5227D9BE.6060009@asianux.com>
In-Reply-To: <5227D9BE.6060009@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 09:09 AM, Chen Gang wrote:
> "include/uapi/" is the whole Linux kernel API, it is important enough
> to get more global explanations by comments.
> 
> In "include/uapi/Kbuild", "Makefile..." and "non-arch..." comments are
> meaningless for current 'Kbuild', so delete them.
> 

Hmm...it is better to improve original comments instead of delete them:
Need give some comments for "arch/*/include/uapi/asm" in
"include/uapi/Kbuild". :-)

> And add more explanations for "include/uapi/" in "include/uapi/Kbuild",
> 

"add more explanations" is still need.


I will send patch v4 for it. :-)

Thanks.

> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  include/uapi/Kbuild |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/Kbuild b/include/uapi/Kbuild
> index 81d2106..287e8d0 100644
> --- a/include/uapi/Kbuild
> +++ b/include/uapi/Kbuild
> @@ -1,7 +1,8 @@
>  # UAPI Header export list
> -# Top-level Makefile calls into asm-$(ARCH)
> -# List only non-arch directories below
> -
> +#
> +# UAPI means "Userspace API" which will be installed to "/usr/include".
> +# Except "linux/", the other current level directories are for compatibility.
> +# It will not accept the new additional current level directories or files.
>  
>  header-y += asm-generic/
>  header-y += linux/
> 


-- 
Chen Gang
