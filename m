Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaJBTxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:53:05 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47014 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaJBTxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:53:01 -0400
Date: Thu, 2 Oct 2014 12:52:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] doc: Document RCU self test boot params
Message-ID: <20141002195253.GU5015@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1411140752-27028-1-git-send-email-bobby.prani@gmail.com>
 <1411140752-27028-3-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411140752-27028-3-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100219-3532-0000-0000-0000051C2BFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 11:32:30AM -0400, Pranith Kumar wrote:
> Document the RCU self test boot parameters in kernel-parameters.txt.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

I have this one queued, please let me know if this is an update.

							Thanx, Paul

> ---
>  Documentation/kernel-parameters.txt | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index c403957..04df74e 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -3054,6 +3054,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			messages.  Disable with a value less than or equal
>  			to zero.
> 
> +	rcupdate.rcu_self_test= [KNL]
> +			Run the RCU early boot self tests
> +
> +	rcupdate.rcu_self_test_bh= [KNL]
> +			Run the RCU bh early boot self tests
> +
> +	rcupdate.rcu_self_test_sched= [KNL]
> +			Run the RCU sched early boot self tests
> +
>  	rdinit=		[KNL]
>  			Format: <full_path>
>  			Run specified binary instead of /init from the ramdisk,
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

