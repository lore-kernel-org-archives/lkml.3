Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaKEXJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:09:14 -0500
Received: from one.firstfloor.org ([193.170.194.197]:43376 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaKEXJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:09:10 -0500
Date: Thu, 6 Nov 2014 00:09:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        backports@vger.kernel.org, linux-kernel@vger.kernel.org,
        yann.morin.1998@free.fr, mmarek@suse.cz, sassmann@kpanic.de
Subject: Re: [PATCH v2 03/13] backports: allow for different backport prefix
Message-ID: <20141105230907.GD12538@two.firstfloor.org>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
 <1415157517-15442-4-git-send-email-mcgrof@do-not-panic.com>
 <1415173596.2589.3.camel@sipsolutions.net>
 <20141105091610.GM12953@wotan.suse.de>
 <1415179364.2589.13.camel@sipsolutions.net>
 <20141105194215.GN12953@wotan.suse.de>
 <1415222258.7485.10.camel@sipsolutions.net>
 <20141105222159.GS12953@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105222159.GS12953@wotan.suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You know, this use case seems unavoidable so I'll just proceed with the
> configurability of it. But note that it seems we're both in agreement
> that right now what you described requires more work before in any way
> shape or form folks start using it for the exact purpose you described.
> I also think Andi Kleen's module namespace might be a much better solution to
> that problem [0], we'd just have to carry the code ourselves as I am not

Just to clarify. My name spaces didn't really provide different
name spaces (like C++), it just added a ACL to exports to make it possible
to do "export only to module N". But the name space itself
was still flat

On the linker side doing real name spaces is probably not too hard,
but it would be difficult for linked in code without special linker
support.

> sure if this is ever going to get upstream as it was originally nacked.

May need to revisit that.

-Andi
