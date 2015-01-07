Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbbAGKLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:11:08 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56464 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbbAGKLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:11:06 -0500
Date: Wed, 7 Jan 2015 10:10:56 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 31/40] arm64: macro whitespace fixes
Message-ID: <20150107101055.GB7485@arm.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-32-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-32-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 03:45:15PM +0000, Michael S. Tsirkin wrote:
> While working on arch/arm64/include/asm/uaccess.h, I noticed
> that one macro within this header is made harder to read because it
> violates a coding style rule: space is missing after comma.
> 
> Fix it up.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---

Acked-by: Will Deacon <will.deacon@arm.com>

Will

>  arch/arm64/include/asm/uaccess.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
> index 9a2069b..07e1ba44 100644
> --- a/arch/arm64/include/asm/uaccess.h
> +++ b/arch/arm64/include/asm/uaccess.h
> @@ -63,7 +63,7 @@ static inline void set_fs(mm_segment_t fs)
>  	current_thread_info()->addr_limit = fs;
>  }
>  
> -#define segment_eq(a,b)	((a) == (b))
> +#define segment_eq(a, b)	((a) == (b))
>  
>  /*
>   * Return 1 if addr < current->addr_limit, 0 otherwise.
> -- 
> MST
> 
> 
