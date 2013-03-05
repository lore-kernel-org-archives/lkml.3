Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab3CEVhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:37:14 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:41938 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3CEVhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:37:12 -0500
Date: Wed, 6 Mar 2013 05:37:32 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, jackm@dev.mellanox.co.il, ogerlitz@mellanox.com,
        roland@purestorage.com, dan.magenheimer@oracle.com, vjaquez@igalia.com,
        rene.sapiens@ti.com, x0095078@ti.com, omar.ramirez@ti.com
Subject: Re: [PATCH 5/7] zcache: convert to idr_alloc()
Message-ID: <20130305213732.GB10826@kroah.com>
References: <1362513772-15174-1-git-send-email-tj@kernel.org>
 <1362513772-15174-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362513772-15174-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 12:02:50PM -0800, Tejun Heo wrote:
> idr_get_new*() and friends are about to be deprecated.  Convert to the
> new idr_alloc() interface.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
> ---
>  drivers/staging/zcache/ramster/tcp.c | 25 ++++++++++---------------
>  1 file changed, 10 insertions(+), 15 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
