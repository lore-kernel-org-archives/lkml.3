Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaKCSSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:18:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:2000 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbaKCSSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:18:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,308,1413270000"; 
   d="scan'208";a="630534235"
Message-ID: <5457C6EA.3080809@intel.com>
Date: Mon, 03 Nov 2014 10:18:18 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, corbet@lwn.net,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lcapitulino@redhat.com
Subject: Re: [PATCH] Documentation: vm: Add 1GB large page support information
References: <1414771317-5721-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1414771317-5721-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2014 09:01 AM, Masanari Iida wrote:
> --- a/Documentation/vm/hugetlbpage.txt
> +++ b/Documentation/vm/hugetlbpage.txt
> @@ -2,7 +2,8 @@
>  The intent of this file is to give a brief summary of hugetlbpage support in
>  the Linux kernel.  This support is built on top of multiple page size support
>  that is provided by most modern architectures.  For example, i386
> -architecture supports 4K and 4M (2M in PAE mode) page sizes, ia64
> +architecture supports 4K and 4M (2M in PAE mode) page sizes, x86_64
> +architecture supports 4K, 2M and 1G (SandyBridge or later) page sizes. ia64
>  architecture supports multiple page sizes 4K, 8K, 64K, 256K, 1M, 4M, 16M,
>  256M and ppc64 supports 4K and 16M.  A TLB is a cache of virtual-to-physical
>  translations.  Typically this is a very scarce resource on processor.

I wouldn't mention SandyBridge.  Not all x86 CPUs are Intel. :)

Also, what of the Intel CPUs like the Xeon Phi or the Atom cores?  I
have an IvyBridge (>= Sandybridge) mobile CPU in this laptop which does
not support 1G pages.

I would axe the i386-specific reference and just say something generic like:

       For example, x86 CPUs normally support 4K and 2M (1G sometimes).


