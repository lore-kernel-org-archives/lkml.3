Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab3APV7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:59:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23632 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671Ab3APV7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:59:06 -0500
Message-ID: <50F72272.8090303@oracle.com>
Date: Wed, 16 Jan 2013 16:58:10 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Senna Tschudin <peter.senna@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] hlist: drop the node parameter from iterators
References: <1358094677-11384-1-git-send-email-sasha.levin@oracle.com> <CA+55aFxFb21Ss=-0FUgzQOzPe1=mS11o7J-+Laco09XJvOk9Fg@mail.gmail.com>
In-Reply-To: <CA+55aFxFb21Ss=-0FUgzQOzPe1=mS11o7J-+Laco09XJvOk9Fg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 03:48 PM, Linus Torvalds wrote:
> On Sun, Jan 13, 2013 at 8:31 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> I'm not sure why, but the hlist for each entry iterators were conceived
>> differently from the list ones. While the list ones are nice and elegant:
> 
> So this patch is probably the RightThing(tm) to do, but it's really
> big and makes me nervous. And the fact that there was already one
> problem in the first version doesn't make me feel any more
> warm-and-fuzzy about it.
> 
> I understand that this kind of patch is nice to apply after the merge
> window has closed, but at the same time, it's now *too* long after the
> merge window closed, and even if it wasn't, I'd really like to feel
> like this has gotten more testing than it obviously has. Or some other
> guarantee that there isn't some other subtle issue hiding there.
> 
> So I am going through patches in my mbox, but I really don't feel safe
> enough about this one to apply it.

I agree about the testing part, I doubt anyone besides Peter and myself
gave it a go.

I guess that if you agree that it should go in once it had some more
testing, it can go into linux-next and sit there for the next couple
of weeks until the next merge window opens.

What would be the best way to do that though? see if akpm would take
it into his tree?


Thanks,
Sasha

