Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915Ab3GPU36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:29:58 -0400
Received: from mail.lang.hm ([64.81.33.126]:53959 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933829Ab3GPU34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:29:56 -0400
Date: Tue, 16 Jul 2013 13:29:27 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Willy Tarreau <w@1wt.eu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
In-Reply-To: <51E593B6.1050607@zytor.com>
Message-ID: <alpine.DEB.2.02.1307161326070.15520@nftneq.ynat.uz>
References: <20130711214830.611455274@linuxfoundation.org> <20130712005023.GB31005@thunk.org> <20130712051451.GC25815@1wt.eu> <alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz> <51E593B6.1050607@zytor.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013, H. Peter Anvin wrote:

> On 07/16/2013 12:19 AM, David Lang wrote:
>> On Fri, 12 Jul 2013, Willy Tarreau wrote:
>>
>>> And maybe in the end, having 1/10 patch cause a regression is not *that*
>>> dramatic, and probably less than not fixing the 9 other bugs. In one case
>>> we rely on -stable to merge the 10 fixes, and on the other case we'd rely
>>> on -stable to just revert one of them.
>>
>> Apologies for the late post, I'm catching up on things, but this jumped
>> out at me.
>>
>> We went through a LOT of pain several years ago when people got into the
>> mindset that a patch was acceptable if it fixed more people than it
>> broke. eliminating that mindset did wonders for kernel stability.
>>
>> Regressions are a lot more of a negative than bugfixes are a positive, a
>> 10:1 ratio of fixes to regressions is _not_ good enough.
>>
>
> In my opinion, there is one exception, and that is when the problem
> being fixed is much more severe than the fix.  *In particular* two
> cases: permanently damaging hardware and corrupting data.  For example:
> no boot, as severe as it is, is much better than either of these two
> scenarios.

True, but the key point of this subthread is that regressions are _really_ bad, 
and in practice it's impossible to do enough testing to guarantee that there 
aren't regressions.

as a result, you should only risk regressions if the problem that is being fixed 
is really important. Just because someone found a bug doesn't make it important 
enough to risk regressions over.

David Lang
