Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaDQTrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:47:15 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:60308 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaDQTqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:46:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140417191646.GA2461@redhat.com>
References: <CALCETrWNWvumFg9Qba0GEOjYop4WYe530tCPtakrhnoCrHqhUQ@mail.gmail.com>
 <1397753323.2628.60.camel@willson.li.ssimo.org> <CALCETrXj6kD3E+vsaWmkrSbaQYTu=c-Hsw640jh4O+FbojYk2g@mail.gmail.com>
 <20140417171256.GB25334@redhat.com> <CALCETrVq4HRpfWOAbZAQbyjuraQd=OxnW=WjSoe5JgBzRStiKg@mail.gmail.com>
 <1397756025.2628.64.camel@willson.li.ssimo.org> <CALCETrVBJFgKwRKBE2jAG6kiGgkJ+MyQiw2nyz5yj0h68kCk9A@mail.gmail.com>
 <1397759013.2628.86.camel@willson.li.ssimo.org> <20140417185023.GA32527@redhat.com>
 <1397761817.2628.113.camel@willson.li.ssimo.org> <20140417191646.GA2461@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 17 Apr 2014 12:46:22 -0700
Message-ID: <CALCETrW3F1+3qF3thrAmuoWVbRveBJ2=owpigh4mv6iAafoQCw@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing cgroup path
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Simo Sorce <ssorce@redhat.com>, Daniel J Walsh <dwalsh@redhat.com>,
        David Miller <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter@redhat.com, cgroups@vger.kernel.org, kay@redhat.com,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 12:16 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Apr 17, 2014 at 03:10:17PM -0400, Simo Sorce wrote:
>
> [..]
>> At this point I think journald people need to give a little bit more
>> details on how they plan to use SO_PASSCGROUP.
>>
>> For my use cases I care only about streams and SO_PEERCGROUP that does
>> not have any of the (perceived) issues of SO_PASSCGROUP.
>
> Ok, so we agree that SO_PEERCGROUP is not a problem. And it solves the
> problem for some of the use cases.
>
> And there is lot of contention on the SO_PASSCGROUP option.
>
> So how about taking one step at a time. Get SO_PEERCGROUP in first and
> then get into more details on how SO_PASSCGROUP will exactly be used and
> then decide what to do.

My only objection to SO_PEERCGROUP is that I don't believe that a
legitimate use case exists.  I think the feature itself is safe to
add.

--Andy
