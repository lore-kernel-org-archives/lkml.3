Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab3FMQN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:13:29 -0400
Received: from longford.logfs.org ([213.229.74.203]:59549 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758320Ab3FMQN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:13:26 -0400
Date: Thu, 13 Jun 2013 10:43:47 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] mm: Implement RLIMIT_RSS
Message-ID: <20130613144347.GA13217@logfs.org>
References: <20130611182921.GB25941@logfs.org>
 <20130611211601.GA29426@cmpxchg.org>
 <20130611215319.GA29368@logfs.org>
 <20130613085732.GB4533@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130613085732.GB4533@bbox>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 June 2013 17:57:32 +0900, Minchan Kim wrote:
> 
> It means you already know the max rss of the application in advance
> so you can use taskstats's hiwater_rss if you don't need to catch
> the moment which rss is over the limit.

I would like to catch the very moment.  Just for my particular needs,
it doesn't matter much if you overshoot by 10% or so.  But eventually
I would like a patch that is off by less than 1% and low-overhead at
the same time.

Jörn

--
Measuring programming progress by lines of code is like measuring aircraft
building progress by weight.
-- Bill Gates
