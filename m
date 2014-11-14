Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161955AbaKNUxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:53:20 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:37564 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161933AbaKNUxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:53:18 -0500
MIME-Version: 1.0
In-Reply-To: <1415998228.1847.3.camel@sipsolutions.net>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com> <1415998228.1847.3.camel@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 14 Nov 2014 12:52:56 -0800
X-Google-Sender-Auth: gYusZtoG1qDiuieTBneT9Qh059Y
Message-ID: <CAB=NE6X_d68Wc=CFAMb_suWJJQgSOSNafHiMwAmC6YhJFEtP1w@mail.gmail.com>
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

On Fri, Nov 14, 2014 at 12:50 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2014-11-11 at 00:14 -0800, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>>
>> This third series should hopefully address all pending feedback.
>> I've split out patches even more, but more importantly have
>> made the parser simpler by both integrating the logic required
>> to understand a backport by identifying the backport by type
>> and strategy, sharing that, and then providing ignore lists on
>> the parsers.
>
> I think from a code change POV I should be OK with this, but I'll
> definitely want to run it and see the differences. I'll have to do that
> next week, it's getting late here.

OK. So I shouldn't merge yet?

  Luis
