Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574Ab3GPQnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:43:09 -0400
Received: from mail.lang.hm ([64.81.33.126]:55970 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933369Ab3GPQnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:43:05 -0400
Date: Tue, 16 Jul 2013 09:42:34 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Takashi Iwai <tiwai@suse.de>
cc: Willy Tarreau <w@1wt.eu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
In-Reply-To: <s5hwqoqv4oo.wl%tiwai@suse.de>
Message-ID: <alpine.DEB.2.02.1307160941290.16723@nftneq.ynat.uz>
References: <20130711214830.611455274@linuxfoundation.org> <20130712005023.GB31005@thunk.org> <20130712051451.GC25815@1wt.eu> <alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz> <s5hwqoqv4oo.wl%tiwai@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013, Takashi Iwai wrote:

> At Tue, 16 Jul 2013 00:19:16 -0700 (PDT),
> David Lang wrote:
>>
>> On Fri, 12 Jul 2013, Willy Tarreau wrote:
>>
>>> And maybe in the end, having 1/10 patch cause a regression is not *that*
>>> dramatic, and probably less than not fixing the 9 other bugs. In one case
>>> we rely on -stable to merge the 10 fixes, and on the other case we'd rely
>>> on -stable to just revert one of them.
>>
>> Apologies for the late post, I'm catching up on things, but this jumped out at
>> me.
>>
>> We went through a LOT of pain several years ago when people got into the mindset
>> that a patch was acceptable if it fixed more people than it broke. eliminating
>> that mindset did wonders for kernel stability.
>>
>> Regressions are a lot more of a negative than bugfixes are a positive, a 10:1
>> ratio of fixes to regressions is _not_ good enough.
>
> IMO, one of the reasons is the nature of stable-release: the stable
> tree is released soon after reviews of patches, so no actual
> regression tests can be done before the release.
>
> For finding a regression, patch reviews won't be enough; all patches
> have been already reviewed, thus essentially they must be all
> positive/good fixes.  And the compile is OK.  So what's the problem?
>
> Maybe some QA period before the release might help, but who would
> care?  (Especially under the situation where everybody has own x.y
> stable tree?)

I am not saying that no regressions will happen (for exactly the reasons that 
you are giving).

what I am complaining about is the attitude that a few regressions are Ok, as 
long as there are more fixes than there are regressions.

David Lang
