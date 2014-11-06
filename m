Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaKFQkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:40:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbaKFQk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:40:28 -0500
Date: Thu, 6 Nov 2014 11:40:05 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-kernel@vger.kernel.org, corbet@lwn.net, linux-mm@kvack.org,
        dave.hansen@intel.com, andi@firstfloor.org
Subject: Re: [PATCH/v2] Documentation: vm: Add 1GB large page support
 information
Message-ID: <20141106114005.34dcbf6c@redhat.com>
In-Reply-To: <1415287875-18820-1-git-send-email-standby24x7@gmail.com>
References: <545AADCC.5030102@intel.com>
	<1415287875-18820-1-git-send-email-standby24x7@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Nov 2014 00:31:15 +0900
Masanari Iida <standby24x7@gmail.com> wrote:

> This patch adds 1GB large page support information in
> Documentation/vm/hugetlbpage.txt
> 
> Reference:
> https://lkml.org/lkml/2014/10/31/366
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  Documentation/vm/hugetlbpage.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbpage.txt
> index b64e0af..f2d3a10 100644
> --- a/Documentation/vm/hugetlbpage.txt
> +++ b/Documentation/vm/hugetlbpage.txt
> @@ -1,8 +1,8 @@
>  
>  The intent of this file is to give a brief summary of hugetlbpage support in
>  the Linux kernel.  This support is built on top of multiple page size support
> -that is provided by most modern architectures.  For example, i386
> -architecture supports 4K and 4M (2M in PAE mode) page sizes, ia64
> +that is provided by most modern architectures.  For example, x86 CPUs normally
> +support 4K and 2M (1G if architecturally supported) page sizes, ia64
>  architecture supports multiple page sizes 4K, 8K, 64K, 256K, 1M, 4M, 16M,
>  256M and ppc64 supports 4K and 16M.  A TLB is a cache of virtual-to-physical
>  translations.  Typically this is a very scarce resource on processor.

Looks good to me:

Reviewed-by: Luiz Capitulino <lcapitulino@redhat.com>
