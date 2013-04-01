Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777Ab3DAUJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:09:32 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:57414 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab3DAUJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:09:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130401184617.GB31435@htj.dyndns.org>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
 <CAAAKZwv9=NFmt6xj1KF2va1i6=UCvka0YkmdOY9JNUMHDOWpGw@mail.gmail.com> <20130401184617.GB31435@htj.dyndns.org>
From: Tim Hockin <thockin@hockin.org>
Date: Mon, 1 Apr 2013 13:09:09 -0700
X-Google-Sender-Auth: kNG_TNgIE4MerVPq4bvcbrzOTV8
Message-ID: <CAAAKZwvemKDLeuKr6wWMUSVczkRVDZKSzYrXXEMcZ8qvcFR0zQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v8
To: Tejun Heo <tj@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 11:46 AM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Apr 01, 2013 at 11:43:03AM -0700, Tim Hockin wrote:
>> A year later - what ever happened with this?  I want it more than ever
>> for Google's use.
>
> I think the conclusion was "use kmemcg instead".

Pardon my ignorance, but... what?  Use kernel memory limits as a proxy
for process/thread counts?  That sounds terrible - I hope I am
misunderstanding?  This task counter patch had several properties that
mapped very well to what we want.

Is it dead in the water?
