Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3CKVq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:46:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28655 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab3CKVq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:46:26 -0400
Date: Tue, 12 Mar 2013 00:46:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mirsal Ennaime <mirsal@mirsal.fr>
Cc: Greg Kroah-Hartman <greg@kroah.com>, devel@driverdev.osuosl.org,
        Brian Swetland <swetland@google.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Subject: Re: [PATCH 1/4] drivers: android: binder: Move the node release code
 to a separate function
Message-ID: <20130311214610.GC9138@mwanda>
References: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
 <1363030315-10229-2-git-send-email-mirsal@mirsal.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363030315-10229-2-git-send-email-mirsal@mirsal.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 08:31:52PM +0100, Mirsal Ennaime wrote:
>  static void binder_deferred_release(struct binder_proc *proc)
>  {
>  	struct binder_transaction *t;
>  	struct rb_node *n;
> -	int threads, nodes, incoming_refs, outgoing_refs, buffers, active_transactions, page_count;
> +	int threads, nodes, incoming_refs, outgoing_refs, nd_refs,
> +		buffers, active_transactions, page_count;

Don't introduce the new "nd_refs" variable.

regards,
dan carpenter

