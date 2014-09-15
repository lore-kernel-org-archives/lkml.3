Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbaIOTHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:07:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:45613 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265AbaIOTHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:07:02 -0400
Date: Mon, 15 Sep 2014 16:06:55 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Chanho Park <chanho61.park@samsung.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: define _DEFAULT_SOURCE for glibc_2.20
Message-ID: <20140915190655.GH11199@kernel.org>
References: <1410487817-13403-1-git-send-email-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410487817-13403-1-git-send-email-chanho61.park@samsung.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 12, 2014 at 11:10:17AM +0900, Chanho Park escreveu:
> _BSD_SOURCE was deprecated in favour of _DEFAULT_SOURCE since glibc
> 2.20[1]. To avoid build warning on glibc2.20, _DEFAULT_SOURCE should
> also be defined.
> 
> [1]: https://sourceware.org/glibc/wiki/Release/2.20

Thanks,

 Applied.
 
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> ---
>  tools/perf/util/util.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index 6686436..333d9d1 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -39,6 +39,8 @@
>  
>  #define _ALL_SOURCE 1
>  #define _BSD_SOURCE 1
> +/* glibc 2.20 deprecates _BSD_SOURCE in favour of _DEFAULT_SOURCE */
> +#define _DEFAULT_SOURCE 1
>  #define HAS_BOOL
>  
>  #include <unistd.h>
> -- 
> 1.9.1
