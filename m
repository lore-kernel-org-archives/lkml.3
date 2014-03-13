Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaCMBV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 21:21:58 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:50689 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaCMBV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 21:21:56 -0400
MIME-Version: 1.0
In-Reply-To: <1394673476.32465.215.camel@willson.li.ssimo.org>
References: <1394657163-7472-1-git-send-email-vgoyal@redhat.com>
 <1394657163-7472-3-git-send-email-vgoyal@redhat.com> <5320CAEC.6030008@amacapital.net>
 <CALCETrUTjN=XKwnO62P9roZtLLuk7_9Oi17Mj_Aa2ZFtZc1gVA@mail.gmail.com>
 <1394658983.32465.203.camel@willson.li.ssimo.org> <CALCETrU29CpcK4dVRD45BGOD7AVEudADiFxOgFgKWkpFzw07eg@mail.gmail.com>
 <1394673476.32465.215.camel@willson.li.ssimo.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Mar 2014 18:21:35 -0700
Message-ID: <CALCETrWbCuKfV4zMkZajDOGhGkKduW0C2L7uHv=vtvqhVeAc6w@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: Implement SO_PEERCGROUP
To: Simo Sorce <ssorce@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 6:17 PM, Simo Sorce <ssorce@redhat.com> wrote:
> On Wed, 2014-03-12 at 14:19 -0700, Andy Lutomirski wrote:
>> On Wed, Mar 12, 2014 at 2:16 PM, Simo Sorce <ssorce@redhat.com> wrote:
>>
>> >
>> > Connection time is all we do and can care about.
>>
>> You have not answered why.
>
> We are going to disclose information to the peer based on policy that
> depends on the cgroup the peer is part of. All we care for is who opened
> the connection, if the peer wants to pass on that information after it
> has obtained it there is nothing we can do, so connection time is all we
> really care about.

Can you give a realistic example?

I could say that I'd like to disclose information to processes based
on their rlimits at the time they connected, but I don't think that
would carry much weight.

--Andy
