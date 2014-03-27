Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbaC0LmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:42:19 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:24652 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754846AbaC0LmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:42:18 -0400
Date: Thu, 27 Mar 2014 11:41:45 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: Will Deacon <Will.Deacon@arm.com>, "rob@landley.net" <rob@landley.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: Fix memory layout typo
Message-ID: <20140327114144.GB20298@arm.com>
References: <1395800601-17088-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395800601-17088-1-git-send-email-zhangwm@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 02:23:21AM +0000, Neil Zhang wrote:
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  Documentation/arm64/memory.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
> index 5e054bf..c2765e2 100644
> --- a/Documentation/arm64/memory.txt
> +++ b/Documentation/arm64/memory.txt
> @@ -39,7 +39,7 @@ ffffffbffbc00000	ffffffbffbdfffff	   2MB		earlyprintk device
>  
>  ffffffbffbe00000	ffffffbffbe0ffff	  64KB		PCI I/O space
>  
> -ffffffbffbe10000	ffffffbcffffffff	  ~2MB		[guard]
> +ffffffbffbe10000	ffffffbffbffffff	  ~2MB		[guard]
>  
>  ffffffbffc000000	ffffffbfffffffff	  64MB		modules

I fixed this in linux-next already as part of 22bd1c91fe1 (arm64: Extend
the PCI I/O space to 16MB).

Thanks.

-- 
Catalin
