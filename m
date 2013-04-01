Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413Ab3DAXSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 19:18:31 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49144 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab3DAXS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:18:29 -0400
Date: Mon, 1 Apr 2013 16:18:24 -0700
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
Message-ID: <20130401231824.GC2487@htj.dyndns.org>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
 <CAAAKZwv9=NFmt6xj1KF2va1i6=UCvka0YkmdOY9JNUMHDOWpGw@mail.gmail.com>
 <20130401184617.GB31435@htj.dyndns.org>
 <CAAAKZwvemKDLeuKr6wWMUSVczkRVDZKSzYrXXEMcZ8qvcFR0zQ@mail.gmail.com>
 <20130401202943.GC31435@htj.dyndns.org>
 <CAAAKZwuZwN68vtk1qO08GXB_OnQNVtqqp+v_NQfP27W0P_aWZw@mail.gmail.com>
 <20130401220309.GA2487@htj.dyndns.org>
 <CAAAKZwuev7Y58ZQNtG+XdFRt0=NedD7zbYTAZbJ95ahBKLVhKA@mail.gmail.com>
 <20130401223500.GB2487@htj.dyndns.org>
 <CAAAKZwvdMUAZ+N5d-cdCJbKUq=t9M6BbCxzOTWnVQQBrg55vhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAKZwvdMUAZ+N5d-cdCJbKUq=t9M6BbCxzOTWnVQQBrg55vhw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 01, 2013 at 03:57:46PM -0700, Tim Hockin wrote:
> I am not limited by kernel memory, I am limited by PIDs, and I need to
> be able to manage them.  memory.kmem.usage_in_bytes seems to be far
> too noisy to be useful for this purpose.  It may work fine for "just
> stop a fork bomb" but not for any sort of finer-grained control.

So, why are you limited by PIDs other than the arcane / weird
limitation that you have whereever that limitation is?

> > If you think you can tilt it the other way, please feel free to try.
> 
> Just because others caved, doesn't make it less of a hack.  And I will
> cave, too, because I don't have time to bang my head against a wall,
> especially when I can see the remnants of other people who have tried.
> 
> We'll work around it, or we'll hack around it, or we'll carry this
> patch in our own tree and just grumble about ridiculous hacks every
> time we have to forward port it.
> 
> I was just hoping that things had worked themselves out in the last year.

It's kinda weird getting this response, as I don't think it has been
particularly walley.  The arguments were pretty sound from what I
recall and Frederic's use case was actually better covered by kmemcg,
so where's the said wall?  And I asked you why your use case is
different and the only reason you gave me is some arbitrary PID
limitation on whatever thing you're using, which you gotta agree is a
pretty hard sell.  So, if you think you have a valid case, please just
explain it.  Why go passive agressive on it?  If you don't have a
valid case for pushing it, yes, you'll have to hack around it - carry
the patches in your tree, whatever, or better, fix the weird PID
problem.

-- 
tejun
