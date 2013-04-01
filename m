Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab3DAU34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:29:56 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:51906 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab3DAU3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:29:54 -0400
Date: Mon, 1 Apr 2013 13:29:43 -0700
From: Tejun Heo <tj@kernel.org>
To: Tim Hockin <thockin@hockin.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <paul@paulmenage.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@gmail.com>, Cgroups <cgroups@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Max Kellermann <mk@cm4all.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v8
Message-ID: <20130401202943.GC31435@htj.dyndns.org>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
 <CAAAKZwv9=NFmt6xj1KF2va1i6=UCvka0YkmdOY9JNUMHDOWpGw@mail.gmail.com>
 <20130401184617.GB31435@htj.dyndns.org>
 <CAAAKZwvemKDLeuKr6wWMUSVczkRVDZKSzYrXXEMcZ8qvcFR0zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAKZwvemKDLeuKr6wWMUSVczkRVDZKSzYrXXEMcZ8qvcFR0zQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 01:09:09PM -0700, Tim Hockin wrote:
> Pardon my ignorance, but... what?  Use kernel memory limits as a proxy
> for process/thread counts?  That sounds terrible - I hope I am

Well, the argument was that process / thread counts were a poor and
unnecessary proxy for kernel memory consumption limit.  IIRC, Johannes
put it as (I'm paraphrasing) "you can't go to Fry's and buy 4k thread
worth of component".

> misunderstanding?  This task counter patch had several properties that
> mapped very well to what we want.
> 
> Is it dead in the water?

After some discussion, Frederic agreed that at least his use case can
be served well by kmemcg, maybe even better - IIRC it was container
fork bomb scenario, so you'll have to argue your way in why kmemcg
isn't a suitable solution for your use case if you wanna revive this.

Thanks.

-- 
tejun
