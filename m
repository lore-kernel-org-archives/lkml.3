Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934282AbaE3RBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:01:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:6466 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932699AbaE3RBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:01:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,942,1392192000"; 
   d="scan'208";a="520325725"
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink
 K_table
From: Tim Chen <tim.c.chen@linux.intel.com>
To: George Spelvin <linux@horizon.com>
Cc: herbert@gondor.apana.org.au, james.guilford@intel.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140530165224.14673.qmail@ns.horizon.com>
References: <20140530165224.14673.qmail@ns.horizon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 May 2014 10:01:11 -0700
Message-ID: <1401469271.2970.472.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-30 at 12:52 -0400, George Spelvin wrote:
> > That's very small (less than 0.2%) so I think it's acceptable.
> 
> Thank you!  May I take this as an Acked-by; ?

Yes, with the caveat that you still have a v3 of this patch
that reorganize the K table to rodata.

Tim
> 
> I'll work on some performance improvements, but they proably
> won't be ready for the 3.16 merge window.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


