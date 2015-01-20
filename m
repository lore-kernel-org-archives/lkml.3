Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbbATQ5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:57:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108AbbATQ5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:57:18 -0500
Date: Tue, 20 Jan 2015 17:57:16 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Greg Thelen <gthelen@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] mm: memcontrol: default hierarchy interface for
 memory v2
Message-ID: <20150120165716.GP25342@dhcp22.suse.cz>
References: <1421767915-14232-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421767915-14232-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And one more thing. Maybe we should consider posting this to linux-api
as well. This is a new user visible interface and it would be good to
have more eyes looking at possible shortcomings.

On Tue 20-01-15 10:31:53, Johannes Weiner wrote:
> Hi Andrew,
> 
> these patches changed sufficiently while in -mm that a rebase makes
> sense.  The change from using "none" in the configuration files to
> "max"/"infinity" requires a do-over of 1/2 and a changelog fix in 2/2.
> 
> I folded all increments, both in-tree and the ones still pending, and
> credited your seq_puts() checkpatch fix, so these two changes are the
> all-encompassing latest versions, and everything else can be dropped.
> 
> Thanks!
> 

-- 
Michal Hocko
SUSE Labs
