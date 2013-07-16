Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502Ab3GPSlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:41:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57664 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933000Ab3GPSlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:41:42 -0400
Message-ID: <51E593B6.1050607@zytor.com>
Date: Tue, 16 Jul 2013 11:40:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Lang <david@lang.hm>
CC: Willy Tarreau <w@1wt.eu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
References: <20130711214830.611455274@linuxfoundation.org> <20130712005023.GB31005@thunk.org> <20130712051451.GC25815@1wt.eu> <alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 12:19 AM, David Lang wrote:
> On Fri, 12 Jul 2013, Willy Tarreau wrote:
> 
>> And maybe in the end, having 1/10 patch cause a regression is not *that*
>> dramatic, and probably less than not fixing the 9 other bugs. In one case
>> we rely on -stable to merge the 10 fixes, and on the other case we'd rely
>> on -stable to just revert one of them.
> 
> Apologies for the late post, I'm catching up on things, but this jumped
> out at me.
> 
> We went through a LOT of pain several years ago when people got into the
> mindset that a patch was acceptable if it fixed more people than it
> broke. eliminating that mindset did wonders for kernel stability.
> 
> Regressions are a lot more of a negative than bugfixes are a positive, a
> 10:1 ratio of fixes to regressions is _not_ good enough.
> 

In my opinion, there is one exception, and that is when the problem
being fixed is much more severe than the fix.  *In particular* two
cases: permanently damaging hardware and corrupting data.  For example:
no boot, as severe as it is, is much better than either of these two
scenarios.

	-hpa

