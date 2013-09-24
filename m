Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3IXMLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:11:45 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:59881 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab3IXMLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:11:43 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Rob Landley <rob@landley.net>
Cc: Pavel Machek <pavel@ucw.cz>, Will Deacon <will.deacon@arm.com>,
        Trivial patch monkey <trivial@kernel.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: new binutils needed for arm in 3.12-rc1
References: <20130923235917.GA30967@amd.pavel.ucw.cz>
	<1379988800.1974.68@driftwood>
Date: Tue, 24 Sep 2013 13:11:38 +0100
In-Reply-To: <1379988800.1974.68@driftwood> (Rob Landley's message of "Mon, 23
	Sep 2013 21:13:20 -0500")
Message-ID: <yw1xpprywhad.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:

> On 09/23/2013 06:59:17 PM, Pavel Machek wrote:
>> During 3.12-rc, Will Deacon introduced code into arch/arm that
>> requires binutils 2.22.
>
> Um, my toolchain is using the last gplv2 snapshot of binutils out of  
> git, which is just past 2.17 and can build armv7 (but not armv8).
>
> Binutils 2.12->2.22 is quite the jump. (11 years.) I'd except some  
> thought to have gone into that? Possibly a mention of it?

I seriously doubt that 2.12 still works at all (I doubt it can even be
built on a modern system).  In my experience, binutils older than 2.19
or so rarely works properly for ARM.

What value is there in maintaining compatibility with a truly ancient
binutils version anyway?

-- 
Måns Rullgård
mans@mansr.com
