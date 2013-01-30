Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab3A3IFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:05:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:44069 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab3A3IFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:05:37 -0500
Date: Tue, 29 Jan 2013 23:16:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: devel@driverdev.osuosl.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 2/4] staging: zsmalloc: remove unused pool name
Message-ID: <20130130041630.GA18809@kroah.com>
References: <1359135978-15119-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1359135978-15119-3-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359135978-15119-3-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 11:46:16AM -0600, Seth Jennings wrote:
> zs_create_pool() currently takes a name argument which is
> never used in any useful way.
> 
> This patch removes it.
> 
> Acked-by: Nitin Gupta <ngupta@vflare.org>
> Acked-by: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Seth Jennnings <sjenning@linux.vnet.ibm.com>
> Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> ---
>  drivers/staging/zram/zram_drv.c          |    2 +-
>  drivers/staging/zsmalloc/zsmalloc-main.c |   11 +++--------
>  drivers/staging/zsmalloc/zsmalloc.h      |    2 +-
>  3 files changed, 5 insertions(+), 10 deletions(-)

As I'm not taking patch 1/4, this patch doesn't apply, sorry.

greg k-h
