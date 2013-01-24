Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab3AXIzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:55:15 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:38281 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3AXIzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:55:12 -0500
Message-ID: <5100F6AD.5050001@synopsys.com>
Date: Thu, 24 Jan 2013 14:24:05 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: [PATCH v2 00/76] Synopsys ARC Linux kernel Port
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <201301181512.14441.arnd@arndb.de>
In-Reply-To: <201301181512.14441.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013 08:42 PM, Arnd Bergmann wrote:
> On Friday 18 January 2013, Vineet Gupta wrote:
>>
> 
> Hi Vineet,
> 
> I've looked at the entire series again now, and it looks very good
> overall, I only had comments for tiny issues. With 76 patches in the
> series, I doubt that anybody is going to look through all of them
> again though. 

v3 series addressing all comments is cooked and am about to send it out. I've made
2 bins of the patches to separate out the ones which have NOT changed since
v2. I'll send them under separate cover letters to make it easier for reviewers -
BTW addition of your ACKs is not being counted as changed - although it's a big
change for the patches :-)

> Are the patches already part of Linux-next? If not,
> I would recommend getting them in there as a preparation for merging
> in 3.9.

I have a few questions/clarifications in that regards.

(1) What are the logistics involved. Does it have to be a tag or a branch
(typically I see people have branches in next).

(2) Can Stephan pull my branch from github or do I need to be setup apriori on
kernel.org. If latter, whom do I need to contact.

(3) That branch will be ARC patches on top of Linus's 3.8 rc4. Actually for my
development, I'd also cherry picked a few patches from linux-next (soft and hard
dependencies from several different *next trees) - hard ones being

f13a366 CONFIG_GENERIC_SIGALTSTACK build breakage with asm-generic/syscalls.h [Al]
b6fca sysctl: Enable IA64 "ignore-unaligned-usertrap" to be used cross-arch [ia64]

Now when I put up a branch for Stephan I guess these should be taken out of ARC
branch otherwise merge into linux-next will fail ?

(4) Above series (pure ARC patches) merges fine in today's linux-next, except for
a patch touching init/Kconfig (already acked by parisc maintainer) which is
slightly different if based off 3.8-rc4 vs. linux-next (because of interim merge)
so I'm hoping my tree doesn't get "dropped" from linux-next because of that. But
then how will it get fixed.


> I would also recommend to only send incremental patches after that,
> as well as new versions of some of the patches if you decide to
> replace them based on comments you get.

Absolutely - I'm tired of rebasing and chopping/merging as well - so anything new
will be on top of these (no rebasing).

Thx,
-Vineet
