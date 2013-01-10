Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab3AJUDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:03:54 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:54291 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab3AJUDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:03:53 -0500
Date: Thu, 10 Jan 2013 20:03:52 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ppoll() stuck on POLLIN while TCP peer is sending
Message-ID: <20130110200352.GA5316@dcvr.yhbt.net>
References: <20130102200848.GA4500@dcvr.yhbt.net>
 <20130104160148.GB3885@suse.de>
 <20130106120700.GA24671@dcvr.yhbt.net>
 <20130107122516.GC3885@suse.de>
 <20130107223850.GA21311@dcvr.yhbt.net>
 <20130108224313.GA13304@suse.de>
 <20130108232325.GA5948@dcvr.yhbt.net>
 <20130109133746.GD13304@suse.de>
 <20130110092511.GA32333@dcvr.yhbt.net>
 <20130110194212.GJ13304@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130110194212.GJ13304@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> wrote:
> Thanks Eric, it's much appreciated. However, I'm still very much in favour
> of a partial revert as in retrospect the implementation of capture took the
> wrong approach. Could you confirm the following patch works for you?
> It's should functionally have the same effect as the first revert and
> there are only minor changes from the last revert prototype I sent you
> but there is no harm in being sure.

Thanks, I was just about to report back on the last partial revert
being successful :)  Will start testing this one, now.
