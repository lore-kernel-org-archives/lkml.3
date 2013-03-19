Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab3CSAWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:22:45 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:54331 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3CSAWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:22:43 -0400
Date: Mon, 18 Mar 2013 17:23:59 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] zcache: Support zero-filled pages more efficiently
Message-ID: <20130319002359.GA29441@kroah.com>
References: <1363314860-22731-1-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363314860-22731-1-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 10:34:15AM +0800, Wanpeng Li wrote:
> Changelog:
>  v2 -> v3:
>   * increment/decrement zcache_[eph|pers]_zpages for zero-filled pages, spotted by Dan 
>   * replace "zero" or "zero page" by "zero_filled_page", spotted by Dan
>  v1 -> v2:
>   * avoid changing tmem.[ch] entirely, spotted by Dan.
>   * don't accumulate [eph|pers]pageframe and [eph|pers]zpages for 
>     zero-filled pages, spotted by Dan
>   * cleanup TODO list
>   * add Dan Acked-by.

In the future, please make the subject: lines have "staging: zcache:" in
them, so I don't have to edit them by hand.

thanks,

greg k-h
