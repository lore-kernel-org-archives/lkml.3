Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3GaFsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 01:48:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40157 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab3GaFsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 01:48:14 -0400
Message-ID: <51F8A4F3.4020003@zytor.com>
Date: Tue, 30 Jul 2013 22:47:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] DT, maintainership, development
 process
References: <20130729102452.GA2682@zurbaran> <3572404.Lna8dKdTsO@vostro.rjw.lan> <20130729181733.GB31172@tuxdriver.com> <4053222.hWzinV5Hra@vostro.rjw.lan>
In-Reply-To: <4053222.hWzinV5Hra@vostro.rjw.lan>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 03:30 PM, Rafael J. Wysocki wrote:
> On Monday, July 29, 2013 02:17:34 PM John W. Linville wrote:
>> On Mon, Jul 29, 2013 at 03:27:44PM +0200, Rafael J. Wysocki wrote:
>>
>>> That said we have the same issue with commits with just two SOB tags if
>>> a maintainer applies a patch that nobody has responded to.  Are they going to
>>> be regarded as "suspicious" too now?
>>>
>>> And what about trusting maintainers?  If Linus trusts them enough to pull from
>>> them, why can't everybody else trust them enough to assume that they don't do
>>> bad things on purpose?
>>
>> Not just Linus -- it's 'turtles all the way down' here.  As someone
>> else suggested, a Singed-off-by in the merge commit should suffice
>> here.  Although, I haven't always made a habit of adding S-o-b to
>> merge commits either...
> 
> An SOB in the merge doesn't provide any additional information that can't
> be retrieved from git, unless you use a different e-mail address for the
> sign-off. :-)
> 

Watch out for fast forward merges.  Ideally I guess maintainers really
should disable fast forwards and PGP-sign their merge commits...

	-hpa


