Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaH3SLi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 14:11:38 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:65272 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaH3SLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 14:11:37 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/2] lib: string: Make all calls to strnicmp into calls to strncasecmp
Organization: D03
References: <1409124962-11527-1-git-send-email-linux@rasmusvillemoes.dk>
	<1409124962-11527-3-git-send-email-linux@rasmusvillemoes.dk>
	<20140827090537.GL5100@mwanda> <87sikie1n7.fsf@rasmusvillemoes.dk>
	<20140827101727.GH5046@mwanda>
X-Hashcash: 1:20:140830:akpm@linux-foundation.org::DWlEef7lKzTtAJlX:0000000000000000000000000000000000000THr
X-Hashcash: 1:20:140830:linux-kernel@vger.kernel.org::/f2AWyryXeUeoCAC:0000000000000000000000000000000000B91
X-Hashcash: 1:20:140830:hpa@linux.intel.com::LujPQ9N0GGYMjI3x:00000000000000000000000000000000000000000020p3
X-Hashcash: 1:20:140830:ak@linux.intel.com::9j0F/DVZcBS+iBPw:00000000000000000000000000000000000000000002wiu
X-Hashcash: 1:20:140830:grant.likely@linaro.org::4qPxiYCJk/n58NP8:000000000000000000000000000000000000005F7H
X-Hashcash: 1:20:140830:dan.carpenter@oracle.com::2i9nPmqCu5cBfWDe:00000000000000000000000000000000000004djG
Date: Sat, 30 Aug 2014 20:11:32 +0200
In-Reply-To: <20140827101727.GH5046@mwanda> (Dan Carpenter's message of "Wed,
	27 Aug 2014 13:17:27 +0300")
Message-ID: <871trxvodn.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27 2014, Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Wed, Aug 27, 2014 at 11:13:16AM +0200, Rasmus Villemoes wrote:
>> Anyway, I was also planning on sending tree-wide patches doing
>> s/strnicmp/strncasecmp/, and then removing the hack from string.h, but I
>> first wanted to get feedback on the first patch and maybe some guidance
>> on how to properly deal with the module issue (e.g., does the kernel
>> need to export a strnicmp symbol forever?).
>
> Once we remove the in kernel users then we can remove the function.
> Don't worry about out of tree modules.

OK, that makes everything simpler. Any objections to the first patch?
Andrew, could you take it through your tree?

Thanks,
Rasmus
