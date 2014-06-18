Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbaFRVC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:02:27 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42633 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbaFRVCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:02:25 -0400
Date: Wed, 18 Jun 2014 23:02:22 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 00/12] mm: memcontrol: naturalize charge lifetime v3
Message-ID: <20140618210222.GA2397@dhcp22.suse.cz>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
 <20140617163615.GD9572@dhcp22.suse.cz>
 <20140618203124.GF7331@cmpxchg.org>
 <20140618133618.663cdce4ee895ff52215065a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618133618.663cdce4ee895ff52215065a@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 18-06-14 13:36:18, Andrew Morton wrote:
> On Wed, 18 Jun 2014 16:31:24 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > I'm just going to resend the latest version with the acks you already
> > provided, and then Andrew can decide whether he wants to take the last
> > two as well right away, depending on testing and conflict resolution
> > preferences and on how optimistic he is that you'll agree with them ;)
> 
> I can merge them and add a note-to-self regarding their status.  That
> way we get a cycle of testing while Michal cogitates.

Sure, that makes sense.

-- 
Michal Hocko
SUSE Labs
