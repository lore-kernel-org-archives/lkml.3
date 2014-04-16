Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaDPRxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:53:46 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:49381 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaDPRxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:53:44 -0400
MIME-Version: 1.0
In-Reply-To: <1397669685.19767.450.camel@willson.li.ssimo.org>
References: <CALCETrURHNmLyccRiF_W8o2ozRMR4AaCjUE=_PU8z1+Pq6X2jQ@mail.gmail.com>
 <20140416002010.GA5035@redhat.com> <CALCETrWzHYN3kKcmDTFDfGhZqE4u9+6XDtiOu5nncbK_7KKH0g@mail.gmail.com>
 <20140416.085743.1614257692560892039.davem@davemloft.net> <CALCETrVv8SPM5xjOVGy7qO2aq3FKtG2uG57J49nO7Wy0-gg0Ew@mail.gmail.com>
 <1397664837.19767.410.camel@willson.li.ssimo.org> <CALCETrXn7b6UuALpGUVoyQYfR2uzk5tj2ABV=dkvtFNgqM5sxQ@mail.gmail.com>
 <1397667766.19767.440.camel@willson.li.ssimo.org> <CALCETrU_yKQVZyVug25cxwQFjWJ7Zf20FY-6ht+RJifXtDdDWg@mail.gmail.com>
 <1397669685.19767.450.camel@willson.li.ssimo.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 16 Apr 2014 10:53:22 -0700
Message-ID: <CALCETrX3srGgO4kSueBOYrFSi5__LoHEExis8uvCE+hwgUTdiw@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing cgroup path
To: Simo Sorce <ssorce@redhat.com>
Cc: David Miller <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>,
        Tejun Heo <tj@kernel.org>, Daniel Walsh <dwalsh@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter@redhat.com, cgroups@vger.kernel.org, kay@redhat.com,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 10:34 AM, Simo Sorce <ssorce@redhat.com> wrote:
> On Wed, 2014-04-16 at 10:29 -0700, Andy Lutomirski wrote:
>> Then please remove SO_PASSCGROUP.
>
> Can you stop demanding changes while demonstrating you haven't well
> understood the needs, let alone the consequences ?
>
> Take a day or 2, put your thoughts together and come back with a clear
> description of your concerns if you still have any, please.

OK, if one of you can give a description of what the needs are.  So
far, I've heard:

SSSD, but there was already a longish thread on why SSSD could solve
all of its problems without any kernel changes at all.  I didn't see a
compelling answer there.

journald for things in containers, but this doesn't seem to me to
require any help from the kernel.

journald for things not in containers.  This one is legit, although it
can be solved, albeit with some races, in current kernels.  Is this
the only example?

--Andy
