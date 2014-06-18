Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaFRUgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:36:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbaFRUgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:36:20 -0400
Date: Wed, 18 Jun 2014 13:36:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 00/12] mm: memcontrol: naturalize charge lifetime v3
Message-Id: <20140618133618.663cdce4ee895ff52215065a@linux-foundation.org>
In-Reply-To: <20140618203124.GF7331@cmpxchg.org>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
	<20140617163615.GD9572@dhcp22.suse.cz>
	<20140618203124.GF7331@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014 16:31:24 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> I'm just going to resend the latest version with the acks you already
> provided, and then Andrew can decide whether he wants to take the last
> two as well right away, depending on testing and conflict resolution
> preferences and on how optimistic he is that you'll agree with them ;)

I can merge them and add a note-to-self regarding their status.  That
way we get a cycle of testing while Michal cogitates.
