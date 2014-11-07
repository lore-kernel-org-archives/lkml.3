Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaKGJqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:46:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:27882 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaKGJql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:46:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,331,1413270000"; 
   d="scan'208";a="618757801"
Message-ID: <1415353596.958.302.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Block: Add blk-mq support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@fb.com,
        ezequiel.garcia@free-electrons.com, dwmw2@infradead.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Nov 2014 11:46:36 +0200
In-Reply-To: <54573B72.1060600@nod.at>
References: <1414933255-3795-1-git-send-email-richard@nod.at>
	 <20141103081821.GA5261@infradead.org> <54573B72.1060600@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 09:23 +0100, Richard Weinberger wrote:
> Am 03.11.2014 um 09:18 schrieb Christoph Hellwig:
> > On Sun, Nov 02, 2014 at 02:00:55PM +0100, Richard Weinberger wrote:
> >> +#define UBIBLOCK_SG_COUNT 64
> > 
> > 
> > Can you document why you choose this number? The default nr_request
> > for the old code would be 128.
> 
> Is 64 a problem? Beside of the fact that I forgot to set blk_queue_max_segments().
> I used this number because 128 seemed a bit high and my goal was to
> keep the memory footprint small.
> This is also why I've set tag_set.queue_depth to 64.

The request was to document, so lets' document the choice.

Artem.

