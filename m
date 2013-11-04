Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3KDU0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:26:33 -0500
Received: from smtp2.ispfabriek.nl ([37.251.0.169]:47152 "EHLO
	smtp2.ispfabriek.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab3KDUVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:21:17 -0500
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Nov 2013 15:21:16 EST
Message-ID: <5277FFC5.4040204@xmsnet.nl>
Date: Mon, 04 Nov 2013 21:12:53 +0100
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130807 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.12 released .. and no merge window yet .. and 4.0 plans?
References: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
In-Reply-To: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 01:10 AM, Linus Torvalds wrote:
 >
...
>
> Anyway..
>
> Onto a totally different topic: we're getting to release numbers where
> I have to take off my socks to count that high again. I'm ok with
> 3.<low teens>, but I don't want us to get to the kinds of crazy
> numbers we had in the 2.x series, so at some point we're going to cut
> over from 3.x to 4.x, just to keep the numbers small and easy to
> remember. We're not there yet, but I would actually prefer to not go
> into the twenties, so I can see it happening in a year or so, and
> we'll have 4.0 follow 3.19 or something like that.
>
> Now, it's just a number (since we've long since given up on
> feature-related releases), and it's at least a year away, so why do I
> even mention it at all?
>
> The reason I mention it is because I've been mulling over something
> Dirk Hohndel said during LinuxCon EU and the kernel summit. He asked
> at the Q&A session whether we could do a release with just stability
> and bug-fixes, and I pooh-poohed it because I didn't see most of us
> having the attention span required for that
> (cough*cough*moronic*woodland creature*cough*cough).

I would not trust 4.0 as a bug free and stable kernel. Now 4.0.99 I 
would trust. Almost that is. because some developer would have asked the 
4.0.y maintainer to commit his one day old 4.x bugfix to the 4.0.y tree 
before lots of people would have tested it.

The 4.0 would only force a stable kernel maintainer to choose that 
kernel as his next stable tree. If he does not 4.0 has no meaning at all.

The 4.0 also does not solve another problem. Since the regression team 
stopped tracking bugs nobody really knows how many bugs have been 
forgotten or ignored. There needs to be some sort of feedback-loop to 
force people to fix problems before they invent new ones. I do not think 
a bug-fix round once every 20 releases will accomplice that

-- 
Hans









