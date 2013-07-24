Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab3GXAP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 20:15:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54598 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3GXAPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 20:15:55 -0400
Message-ID: <51EF1C7E.8030903@infradead.org>
Date: Tue, 23 Jul 2013 17:14:54 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/Changes: phase out Changes file that hasn't
 changed
References: <1374621001.3031.1@driftwood>
In-Reply-To: <1374621001.3031.1@driftwood>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/13 16:10, Rob Landley wrote:
> On 07/23/2013 05:57:15 PM, Aaro Koskinen wrote:
>> Hi,
>>
>> On Sun, Jul 21, 2013 at 01:12:55AM -0400, Paul Gortmaker wrote:
>> > Looking at the bigger picture, the need for this file has simply
>> > passed.  It was trying to detail required versions of userspace
>> > packages, in order to cater to hand-crafted systems.  But now the
>> > majority of users get their userspace all at once from some kind
>> > of distro, and we are probably a lot more serious about avoiding
>> > breaking userspace than we were a dozen years ago.
> 
> You're right, there's no such thing as "embedded linux", nobody creates their own hand-crafted systems, or assembles cross-compiling environments to target hardware other than x86. That's crazy talk.
> 
>> Is there any file describing the needed tools (and minimum versions) to
>> _build_ the kernel? I agree that trying to describe such for the run-time
>> userspace does not belong to the kernel tree, but the required/supported
>> versions of build tools should be still maybe documented...
> 
> Documentation/changes _is_ the file that describes the kernel's build-time prerequisites. It hasn't changed in a while because we've been maintaining backwards compatability, especially for several non-x86 targets where it's fiddly to get newer toolchain versions.

and if this file is removed, I'll just have to refer to it in older kernel releases
to at least get hints about what tools to use, where to find them, and what
used to be the version requirements....

> (Personally I use the last GPLv2 releases of each package, so gcc 4.2.1, binutils 2.17, make 3.81, and busybox.)
> 
> I agree squashfs and such aren't build time prerequisites. It might make more sense to move some of these to menuconfig text for the appropriate option. But that's not the same as not documenting it at all, and "this document has been true for a long time and remains true, therefore we must discard it" strikes me as a really weird document retention criteria.



-- 
~Randy
