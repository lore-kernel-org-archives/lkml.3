Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3HUSUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:20:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37692 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3HUSUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:20:12 -0400
Message-ID: <521504D7.7090204@wwwdotorg.org>
Date: Wed, 21 Aug 2013 12:20:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
References: <20130820224032.GA20491@kroah.com>
In-Reply-To: <20130820224032.GA20491@kroah.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 04:40 PM, Greg KH wrote:
> Hi all,
> 
> Given that I had to just revert a patch in the recent stable releases
> that didn't get enough time to "bake" in Linus's tree (or in -next), I
> figured it was worth discussing some possible changes with how "fast" I
> pick up patches for stable releases.
> 
> So, how about this proposal:
> 
> - I will wait for a -rc to come out with the patch in it before putting
>   it into a stable release, unless: [...]

Presumably the idea is that much useful testing only happens on -rc
kernels rather than linux-next or arbitrary points in Linus' tree.

If so, then don't you want to wait for two -rc releases to come out that
include the patch?

When the first -rc that contains the patch is released, people will test
it then. This won't happen immediately, but might take a few days.

By the time the second -rc that contains the patch is released, that's
presumably enough time for people to have tested the first -rc, and
hence we then presume the patch doesn't cause too many issues.

That's still only an average of 1.5 weeks delay, with a min-max of 1-2,
ignoring the merge window and assuming bugfix patches go quickly
upstream from subsystem maintainers.
