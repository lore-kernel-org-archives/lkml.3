Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab3KMCkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 21:40:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab3KMCkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 21:40:03 -0500
Date: Wed, 13 Nov 2013 11:42:52 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, lliubbo@gmail.com,
        jmarchan@redhat.com, mgorman@suse.de, riel@redhat.com,
        hughd@google.com, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Luigi Semenzato <semenzato@google.com>
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
Message-ID: <20131113024252.GA1023@kroah.com>
References: <20131107070451.GA10645@bbox>
 <20131112154137.GA3330@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112154137.GA3330@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 12:41:38AM +0900, Minchan Kim wrote:
> We spent much time with preventing zram enhance since it have been in staging
> and Greg never want to improve without promotion.

It's not "improve", it's "Greg does not want you adding new features and
functionality while the code is in staging."  I want you to spend your
time on getting it out of staging first.

Now if something needs to be done based on review and comments to the
code, then that's fine to do and I'll accept that, but I've been seeing
new functionality be added to the code, which I will not accept because
it seems that you all have given up on getting it merged, which isn't
ok.

thanks,

greg k-h
