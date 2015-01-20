Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbbATRAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:00:16 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38894 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbbATRAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:00:13 -0500
MIME-Version: 1.0
In-Reply-To: <20150120143644.GL25342@dhcp22.suse.cz>
References: <1421508107-29377-1-git-send-email-hannes@cmpxchg.org>
	<20150120133711.GI25342@dhcp22.suse.cz>
	<20150120143002.GB11181@phnom.home.cmpxchg.org>
	<20150120143644.GL25342@dhcp22.suse.cz>
Date: Tue, 20 Jan 2015 12:00:11 -0500
X-Google-Sender-Auth: uhnQzXPXnj7yb3LBIuwRE_h34BA
Message-ID: <CAOS58YNZFuSP6cKLAkYKkK+QUDxwngnKE5UGHmAL7n3PygraaQ@mail.gmail.com>
Subject: Re: [patch] mm: memcontrol: default hierarchy interface for memory
 fix - "none"
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Greg Thelen <gthelen@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 20, 2015 at 9:36 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Tue 20-01-15 09:30:02, Johannes Weiner wrote:
> [...]
>> Another possibility would be "infinity",
>
> yes infinity definitely sounds much better to me.

FWIW, I prefer "max". It's shorter and clear enough. I don't think
there's anything ambiguous about "the memory max limit is at its
maximum". No need to introduce a different term.

Thanks.

-- 
tejun
