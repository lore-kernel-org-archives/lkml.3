Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaHYRyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:54:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaHYRyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:54:51 -0400
Date: Mon, 25 Aug 2014 13:54:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Geoff Levand <geoff@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, kexec@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] kexec: Add IND_FLAGS macro
Message-ID: <20140825175400.GG14379@redhat.com>
References: <cover.1408731991.git.geoff@infradead.org>
 <c2d710e956591376b08bcbc3f904efd9b0c8b912.1408731991.git.geoff@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2d710e956591376b08bcbc3f904efd9b0c8b912.1408731991.git.geoff@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 06:39:47PM +0000, Geoff Levand wrote:
> Add a new kexec preprocessor macro IND_FLAGS, which is the bitwise OR of
> all the possible kexec IND_ kimage_entry indirection flags.
> 
> Having this macro allows for simplified code in the prosessing of the
> kexec kimage_entry items.
> 
> Signed-off-by: Geoff Levand <geoff@infradead.org>

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  include/linux/kexec.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index 8c628ca..a4758f9 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -10,6 +10,7 @@
>  #define IND_INDIRECTION  (1 << IND_INDIRECTION_BIT)
>  #define IND_DONE         (1 << IND_DONE_BIT)
>  #define IND_SOURCE       (1 << IND_SOURCE_BIT)
> +#define IND_FLAGS (IND_DESTINATION | IND_INDIRECTION | IND_DONE | IND_SOURCE)
>  
>  #if !defined(__ASSEMBLY__)
>  
> -- 
> 1.9.1
> 
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
