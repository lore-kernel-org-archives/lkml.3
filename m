Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab3E3XnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 19:43:08 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:52435 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab3E3Xm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 19:42:56 -0400
Date: Fri, 31 May 2013 08:43:39 +0900
From: Simon Horman <horms@verge.net.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree
 (net-next tree related)
Message-ID: <20130530234339.GC31349@verge.net.au>
References: <20130530161757.e04eaefc2f3cf64c1135aac1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130530161757.e04eaefc2f3cf64c1135aac1@canb.auug.org.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 04:17:57PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (i386 defconfig)
> produced this warning:
> 
> net/netfilter/nf_nat_helper.c: In function 'mangle_contents':
> net/netfilter/nf_nat_helper.c:108:9: warning: passing argument 3 of 'memmove' makes integer from pointer without a cast [enabled by default]
> arch/x86/include/asm/string_32.h:200:7: note: expected 'size_t' but argument is of type 'sk_buff_data_t'
> 
> Presumably introduced by commit 1a37e412a022 ("net: Use 16bits for
> *_headers fields of struct skbuff").

Thanks Stephen.

I believe that you are correct. I'll prepare and post a patch ASAP.

