Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaKCOZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:25:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbaKCOZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:25:05 -0500
Date: Mon, 3 Nov 2014 09:24:57 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Documentation: vm: Add 1GB large page support
 information
Message-ID: <20141103092457.66577a21@redhat.com>
In-Reply-To: <1414771317-5721-1-git-send-email-standby24x7@gmail.com>
References: <1414771317-5721-1-git-send-email-standby24x7@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  1 Nov 2014 01:01:57 +0900
Masanari Iida <standby24x7@gmail.com> wrote:

> This patch add 1GB large page support information on
> x86_64 architecture in Documentation/vm/hugetlbpage.txt.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  Documentation/vm/hugetlbpage.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbpage.txt
> index bdd4bb9..0a2bf4f 100644
> --- a/Documentation/vm/hugetlbpage.txt
> +++ b/Documentation/vm/hugetlbpage.txt
> @@ -2,7 +2,8 @@
>  The intent of this file is to give a brief summary of hugetlbpage support in
>  the Linux kernel.  This support is built on top of multiple page size support
>  that is provided by most modern architectures.  For example, i386
> -architecture supports 4K and 4M (2M in PAE mode) page sizes, ia64
> +architecture supports 4K and 4M (2M in PAE mode) page sizes, x86_64
> +architecture supports 4K, 2M and 1G (SandyBridge or later) page sizes. ia64

Good catch, but does it make sense to mention SandyBridge? Doesn't it makes
it Intel specific? What about mentioning the pdpe1gb flag instead?

>  architecture supports multiple page sizes 4K, 8K, 64K, 256K, 1M, 4M, 16M,
>  256M and ppc64 supports 4K and 16M.  A TLB is a cache of virtual-to-physical
>  translations.  Typically this is a very scarce resource on processor.

