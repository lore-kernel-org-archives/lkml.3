Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3IYRcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:32:24 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51595 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab3IYRcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:32:23 -0400
Message-ID: <52431CEE.9000907@ahsoftware.de>
Date: Wed, 25 Sep 2013 19:27:10 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Find CamelCase definitions of struct/union/enum
References: <1380047934.3575.100.camel@joe-AO722> <20130925152432.GY13318@ZenIV.linux.org.uk> <1380123344.17366.5.camel@joe-AO722> <20130925161949.GZ13318@ZenIV.linux.org.uk>
In-Reply-To: <20130925161949.GZ13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.09.2013 18:19, schrieb Al Viro:
> On Wed, Sep 25, 2013 at 08:35:44AM -0700, Joe Perches wrote:
>
>> We disagree.
>
> Obviously.
>
>> I think Propercase should be discouraged.
>> ie: Qdisc et al.
>
> Excuse me, but "Joe happens to think that something should be discouraged"
> is not a problem.  "Joe uses checkpatch.pl as force multiplier, recruiting
> hundreds of monkeys to enforce his personal preferences", OTOH, very much is.
>
> You are calling for ban on any mixed-case identifiers.  I see at least three
> cases where they can be legitimate:
> 	* labels a-la Enomem, etc.  I've been using those and I will
> keep doing so, checkpatch.pl and its users be damned.
> 	* enum members, to distinguish those from defines (first letter
> capitalized vs. all-caps).
> 	* (local) typedefs for structs; I really don't like their use for
> anything non-local, but IMO they have their uses in cases like e.g.
> fs/binfmt_misc.c

Besides that CamelCase is one character less long than camel_case.

I'm awaiting kernel developer uniforms. There are too many different 
black t-shirts around. ;)

Regards,

Alexander Holler

