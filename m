Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021AbaKEXQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:16:14 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:60151 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaKEXQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:16:11 -0500
MIME-Version: 1.0
In-Reply-To: <20141105230907.GD12538@two.firstfloor.org>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
 <1415157517-15442-4-git-send-email-mcgrof@do-not-panic.com>
 <1415173596.2589.3.camel@sipsolutions.net> <20141105091610.GM12953@wotan.suse.de>
 <1415179364.2589.13.camel@sipsolutions.net> <20141105194215.GN12953@wotan.suse.de>
 <1415222258.7485.10.camel@sipsolutions.net> <20141105222159.GS12953@wotan.suse.de>
 <20141105230907.GD12538@two.firstfloor.org>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Wed, 5 Nov 2014 15:15:48 -0800
X-Google-Sender-Auth: k-J0MCXeqMAXBT0cEGw8Hhzzu9s
Message-ID: <CAB=NE6Wu7gFh+_1ebiaWCq2cUt_SnCMB-+1Xv9ZuZtBafdg0Vg@mail.gmail.com>
Subject: Re: [PATCH v2 03/13] backports: allow for different backport prefix
To: Andi Kleen <andi@firstfloor.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Michal Marek <mmarek@suse.cz>, Stefan Assmann <sassmann@kpanic.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 3:09 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> You know, this use case seems unavoidable so I'll just proceed with the
>> configurability of it. But note that it seems we're both in agreement
>> that right now what you described requires more work before in any way
>> shape or form folks start using it for the exact purpose you described.
>> I also think Andi Kleen's module namespace might be a much better solution to
>> that problem [0], we'd just have to carry the code ourselves as I am not
>
> Just to clarify. My name spaces didn't really provide different
> name spaces (like C++), it just added a ACL to exports to make it possible
> to do "export only to module N". But the name space itself
> was still flat

Indeed that is how I understood it and the use case in mind for
backporting different subsystems from different future versions of
Linux to an older one might be a use case here (although insane).

> On the linker side doing real name spaces is probably not too hard,
> but it would be difficult for linked in code without special linker
> support.

Good to know, perhaps useful for folks who really do consider
embarking on this strategy with backports (although I don't recommend
it).

>> sure if this is ever going to get upstream as it was originally nacked.
>
> May need to revisit that.

The only thing that was not clear to me from reviewing the module
namespace stuff a while ago was the original intent, but I confess I
actually only looked at the technical details to see if it was
applicable to the backports case, do you recall the original
motivation ?

 Luis
