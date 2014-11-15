Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbaKOBVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 20:21:21 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:60121 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbaKOBVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 20:21:19 -0500
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XVsZaUebqpKWZhPXncDY-5NRXorYSGQQZC00a9ezJouQ@mail.gmail.com>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
 <1415998228.1847.3.camel@sipsolutions.net> <CAB=NE6X_d68Wc=CFAMb_suWJJQgSOSNafHiMwAmC6YhJFEtP1w@mail.gmail.com>
 <1415998465.1847.4.camel@sipsolutions.net> <CAB=NE6XVsZaUebqpKWZhPXncDY-5NRXorYSGQQZC00a9ezJouQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 14 Nov 2014 17:20:57 -0800
X-Google-Sender-Auth: pY0bZ9AlMwhXrbgmq4d23PYaGt8
Message-ID: <CAB=NE6VYK72LsdPfcaY1vjMtr-kRq-6vMwfV7bmzT5y1bX3i1A@mail.gmail.com>
Subject: Re: [PATCH v3 00/21] backports: add kernel integration support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Michal Marek <mmarek@suse.cz>, Stefan Assmann <sassmann@kpanic.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 1:10 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Fri, Nov 14, 2014 at 12:54 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Fri, 2014-11-14 at 12:52 -0800, Luis R. Rodriguez wrote:
>>> On Fri, Nov 14, 2014 at 12:50 PM, Johannes Berg
>>> <johannes@sipsolutions.net> wrote:
>>> > On Tue, 2014-11-11 at 00:14 -0800, Luis R. Rodriguez wrote:
>>> >> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>>> >>
>>> >> This third series should hopefully address all pending feedback.
>>> >> I've split out patches even more, but more importantly have
>>> >> made the parser simpler by both integrating the logic required
>>> >> to understand a backport by identifying the backport by type
>>> >> and strategy, sharing that, and then providing ignore lists on
>>> >> the parsers.
>>> >
>>> > I think from a code change POV I should be OK with this, but I'll
>>> > definitely want to run it and see the differences. I'll have to do that
>>> > next week, it's getting late here.
>>>
>>> OK. So I shouldn't merge yet?
>>
>> I would prefer you didn't, but OTOH we can always fix up issues later as
>> well.
>
> I'll wait.

Pushed.

 Luis
