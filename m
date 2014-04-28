Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbaD1X5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:57:32 -0400
Received: from mail.anarazel.de ([217.115.131.40]:38212 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554AbaD1X5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:57:30 -0400
Date: Tue, 29 Apr 2014 01:57:14 +0200
From: Andres Freund <andres@anarazel.de>
To: Dave Chinner <david@fromorbit.com>
Cc: rhaas@anarazel.de, linux-kernel@vger.kernel.org,
        lsf@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [Lsf] Postgresql performance problems with IO latency,
 especially during fsync()
Message-ID: <20140428235714.GA16070@awork2.anarazel.de>
References: <20140326191113.GF9066@alap3.anarazel.de>
 <20140409092009.GA27519@dastard>
 <20140428234756.GM15995@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428234756.GM15995@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On 2014-04-29 09:47:56 +1000, Dave Chinner wrote:
> ping?

I'd replied at http://marc.info/?l=linux-mm&m=139730910307321&w=2

As an additional note:

> On Wed, Apr 09, 2014 at 07:20:09PM +1000, Dave Chinner wrote:
> > I'm not sure how you were generating the behaviour you reported, but
> > the test program as it stands does not appear to be causing any
> > problems at all on the sort of storage I'd expect large databases to
> > be hosted on....

A really really large number of database aren't stored on big enterprise
rigs...

Andres Freund

-- 
 Andres Freund	                   http://www.2ndQuadrant.com/
 PostgreSQL Development, 24x7 Support, Training & Services
