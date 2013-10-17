Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355Ab3JQWgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 18:36:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37064 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab3JQWgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 18:36:19 -0400
Date: Thu, 17 Oct 2013 16:36:16 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Miller <mike.miller@hp.com>, LKML-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] remove cpqarray from mainline kernel
Message-ID: <20131017223616.GB32575@kernel.dk>
References: <20131017175226.GA31535@thumper.usa.hp.com>
 <20131017141337.425f84c630ffe1c7c61c4dc4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017141337.425f84c630ffe1c7c61c4dc4@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17 2013, Andrew Morton wrote:
> On Thu, 17 Oct 2013 12:52:26 -0500 Mike Miller <mike.miller@hp.com> wrote:
> 
> > cpqarray hasn't been used in over 12 years. It's doubtful that anyone still
> > uses the board. It's time the driver was removed from the mainline kernel.
> > The only updates these days are minor and mostly done by people outside of HP.
> 
> It's amazing the weird stuff people get up to.  Perhaps we should disable
> it in config for a cycle or two, see if that flushes anyone out?

I think that would be prudent, you never know what people run...

-- 
Jens Axboe

