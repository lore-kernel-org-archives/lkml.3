Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3A3IVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:21:19 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60065 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3A3IVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:21:16 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-cb-5108d7f9a44a
Date: Wed, 30 Jan 2013 17:21:12 +0900
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, stable@vger.kernel.org,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [RESEND PATCH v5 1/4] zram: Fix deadlock bug in partial write
Message-ID: <20130130082112.GA23548@blaptop>
References: <1359333506-13599-1-git-send-email-minchan@kernel.org>
 <20130130042006.GA24538@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130042006.GA24538@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, Jan 29, 2013 at 11:20:06PM -0500, Greg Kroah-Hartman wrote:
> On Mon, Jan 28, 2013 at 09:38:23AM +0900, Minchan Kim wrote:
> > Now zram allocates new page with GFP_KERNEL in zram I/O path
> > if IO is partial. Unfortunately, It may cuase deadlock with
> > reclaim path so this patch solves the problem.
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Jerome Marchand <jmarchan@redhat.com>
> > Acked-by: Nitin Gupta <ngupta@vflare.org>
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  drivers/staging/zram/zram_drv.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Due to the discussion on this series, I don't know what patch to apply,
> so care to do a v6 of this with the patches that everyone has finally
> agreed on?

I already sent v6.
https://lkml.org/lkml/2013/1/29/680

Thanks.

-- 
Kind regards,
Minchan Kim
