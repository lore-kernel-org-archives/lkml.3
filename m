Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab3DAWfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:35:08 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:39263 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab3DAWfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:35:05 -0400
Date: Mon, 1 Apr 2013 15:35:00 -0700
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
Message-ID: <20130401223500.GB2487@htj.dyndns.org>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
 <CAAAKZwv9=NFmt6xj1KF2va1i6=UCvka0YkmdOY9JNUMHDOWpGw@mail.gmail.com>
 <20130401184617.GB31435@htj.dyndns.org>
 <CAAAKZwvemKDLeuKr6wWMUSVczkRVDZKSzYrXXEMcZ8qvcFR0zQ@mail.gmail.com>
 <20130401202943.GC31435@htj.dyndns.org>
 <CAAAKZwuZwN68vtk1qO08GXB_OnQNVtqqp+v_NQfP27W0P_aWZw@mail.gmail.com>
 <20130401220309.GA2487@htj.dyndns.org>
 <CAAAKZwuev7Y58ZQNtG+XdFRt0=NedD7zbYTAZbJ95ahBKLVhKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAKZwuev7Y58ZQNtG+XdFRt0=NedD7zbYTAZbJ95ahBKLVhKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Apr 01, 2013 at 03:20:47PM -0700, Tim Hockin wrote:
> > Ummmm.... so that's why you guys can't use kernel memory limit? :(
> 
> Because it is completely non-obvious how to map between the two in a
> way that is safe across kernel versions and not likely to blow up in
> our faces.  It's a hack, in other words.

Now we're repeating the argument Frederic and Johannes had, so I'd
suggest going back the thread and reading the discussion and if you
still think using kmemcg is a bad idea, please explain why that is so.
For the specific point that you just raised, the scale tilted toward
thread/process count is a hacky and unreliable representation of
kernel memory resource than the other way around, at least back then.
If you think you can tilt it the other way, please feel free to try.

Thanks.

-- 
tejun
