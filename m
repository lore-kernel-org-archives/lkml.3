Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaK1Q1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:27:24 -0500
Received: from mail.us.es ([193.147.175.20]:50900 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaK1Q1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:27:22 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus5 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19692. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.2/7.5):. 
 Processed in 1.973105 secs); 28 Nov 2014 16:27:19 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Fri, 28 Nov 2014 17:29:25 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] nf_log_ipv6: correct typo in module description
Message-ID: <20141128162925.GA3729@salvia>
References: <1417155739-5263-1-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417155739-5263-1-git-send-email-steven@uplinklabs.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 10:22:19PM -0800, Steven Noonan wrote:
> It incorrectly identifies itself as "IPv4" packet logging.

Applied.

Please, Cc netfilter-devel@vger.kernel.org in your future patches.

Thanks.

> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> ---
>  net/ipv6/netfilter/nf_log_ipv6.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/netfilter/nf_log_ipv6.c b/net/ipv6/netfilter/nf_log_ipv6.c
> index 7b17a0b..41b9ade 100644
> --- a/net/ipv6/netfilter/nf_log_ipv6.c
> +++ b/net/ipv6/netfilter/nf_log_ipv6.c
> @@ -412,6 +412,6 @@ module_init(nf_log_ipv6_init);
>  module_exit(nf_log_ipv6_exit);
>  
>  MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
> -MODULE_DESCRIPTION("Netfilter IPv4 packet logging");
> +MODULE_DESCRIPTION("Netfilter IPv6 packet logging");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_NF_LOGGER(AF_INET6, 0);
> -- 
> 2.1.3
> 
