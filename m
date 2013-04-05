Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161859Ab3DEORl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 10:17:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161777Ab3DEORk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:17:40 -0400
Date: Fri, 5 Apr 2013 16:17:38 +0200
From: Jan Kara <jack@suse.cz>
To: Raymond Jennings <shentino@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: block device queues, elevatoring implicit or explicit?
Message-ID: <20130405141738.GB21852@quack.suse.cz>
References: <CAGDaZ_pHn=ZHJ-cRy5am5w+EYpspfRTKvhmyDCcLVLH=T0Y2Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGDaZ_pHn=ZHJ-cRy5am5w+EYpspfRTKvhmyDCcLVLH=T0Y2Sw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 16-03-13 02:06:00, Raymond Jennings wrote:
> Are all block devices fundamentally elevators or fifos or what?
> 
> To be blunt, if a bunch of concurrent processes dump requests on a
> noop queue, are they serviced fifo or in elevator order or what?
> 
> My goal is to get a dumb elevator that does nothing but sweep up and
> down the disk mopping up outstanding requests as the disk heads ooze
> across the sectors.
  With noop io scheduler you get the FIFO ordering of requests.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
