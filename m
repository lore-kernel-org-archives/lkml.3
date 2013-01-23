Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3AWAGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:06:52 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60651 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3AWAGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:06:50 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-ee-50ff299810b5
Date: Wed, 23 Jan 2013 09:06:48 +0900
From: Minchan Kim <minchan@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, jmarchan@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 1/4] zram: Fix deadlock bug in partial write
Message-ID: <20130123000648.GA2723@blaptop>
References: <1358898745-4873-1-git-send-email-minchan@kernel.org>
 <CAPkvG_f2mDr2p=ypqcikeNMRoE3tK1-kDjLWyz6bb9yQUpGgZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPkvG_f2mDr2p=ypqcikeNMRoE3tK1-kDjLWyz6bb9yQUpGgZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

On Tue, Jan 22, 2013 at 03:58:10PM -0800, Nitin Gupta wrote:
> On Tue, Jan 22, 2013 at 3:52 PM, Minchan Kim <minchan@kernel.org> wrote:
> > Now zram allocates new page with GFP_KERNEL in zram I/O path
> > if IO is partial. Unfortunately, It may cuase deadlock with
> > reclaim path so this patch solves the problem.
> >
> > Cc: Jerome Marchand <jmarchan@redhat.com>
> > Cc: stable@vger.kernel.org
> > Acked-by: Nitin Gupta <ngupta@vflare.org>
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  drivers/staging/zram/zram_drv.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> 
> Changelog for v4 vs v5?

It's just adding your Acked-by in whole series.
I thought it's minor.

Thanks for the review, Nitin.

> 
> Thanks,
> Nitin
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
