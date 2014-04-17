Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaDQTRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:17:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbaDQTQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:16:52 -0400
Date: Thu, 17 Apr 2014 15:16:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Simo Sorce <ssorce@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Daniel J Walsh <dwalsh@redhat.com>,
        David Miller <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter@redhat.com, cgroups@vger.kernel.org, kay@redhat.com,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing
 cgroup path
Message-ID: <20140417191646.GA2461@redhat.com>
References: <CALCETrWNWvumFg9Qba0GEOjYop4WYe530tCPtakrhnoCrHqhUQ@mail.gmail.com>
 <1397753323.2628.60.camel@willson.li.ssimo.org>
 <CALCETrXj6kD3E+vsaWmkrSbaQYTu=c-Hsw640jh4O+FbojYk2g@mail.gmail.com>
 <20140417171256.GB25334@redhat.com>
 <CALCETrVq4HRpfWOAbZAQbyjuraQd=OxnW=WjSoe5JgBzRStiKg@mail.gmail.com>
 <1397756025.2628.64.camel@willson.li.ssimo.org>
 <CALCETrVBJFgKwRKBE2jAG6kiGgkJ+MyQiw2nyz5yj0h68kCk9A@mail.gmail.com>
 <1397759013.2628.86.camel@willson.li.ssimo.org>
 <20140417185023.GA32527@redhat.com>
 <1397761817.2628.113.camel@willson.li.ssimo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397761817.2628.113.camel@willson.li.ssimo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 03:10:17PM -0400, Simo Sorce wrote:

[..]
> At this point I think journald people need to give a little bit more
> details on how they plan to use SO_PASSCGROUP.
> 
> For my use cases I care only about streams and SO_PEERCGROUP that does
> not have any of the (perceived) issues of SO_PASSCGROUP.

Ok, so we agree that SO_PEERCGROUP is not a problem. And it solves the
problem for some of the use cases.

And there is lot of contention on the SO_PASSCGROUP option.

So how about taking one step at a time. Get SO_PEERCGROUP in first and
then get into more details on how SO_PASSCGROUP will exactly be used and
then decide what to do.

Thanks
Vivek
