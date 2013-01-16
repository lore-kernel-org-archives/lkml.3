Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab3APWSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:18:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28196 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136Ab3APWSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:18:34 -0500
Message-ID: <50F72706.5090900@oracle.com>
Date: Wed, 16 Jan 2013 17:17:42 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Senna Tschudin <peter.senna@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] hlist: drop the node parameter from iterators
References: <1358094677-11384-1-git-send-email-sasha.levin@oracle.com> <CA+55aFxFb21Ss=-0FUgzQOzPe1=mS11o7J-+Laco09XJvOk9Fg@mail.gmail.com> <50F72272.8090303@oracle.com> <CA+55aFxjwW4Ppv-73WHh-RqeFvq+Bjr3o08ZuKkiWuwAVMkqFQ@mail.gmail.com>
In-Reply-To: <CA+55aFxjwW4Ppv-73WHh-RqeFvq+Bjr3o08ZuKkiWuwAVMkqFQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 05:04 PM, Linus Torvalds wrote:
> On Wed, Jan 16, 2013 at 1:58 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>
>> I guess that if you agree that it should go in once it had some more
>> testing, it can go into linux-next and sit there for the next couple
>> of weeks until the next merge window opens.
> 
> So linux-next gets compile testing and warns about conflicts. But
> almost nobody really runs the end result.

I do :)

I also know that people run ltp tests on top of those builds, so while
it's not as good as actually working with it, it's also not
insignificant.

> Now, *hopefully* the compile problems and conflicts are the major
> issue, but at the same time, I worry about some actual subtle semantic
> breakage. I'm not sure how it would happen, but it's a big patch..
> 
>> What would be the best way to do that though? see if akpm would take
>> it into his tree?
> 
> That would help. As would just linux-next. As would just after the
> next merge window closes, if you can send it almost immediately *and*
> have the "at least the patch has been around for a long time with no
> *known* breakage" note. Because at some point, I guess we can't do
> much more than that.

Alrighty, right after merge window it is. The -rc4 period is what you
told me the last time I sent this patch, so I went with that this time.

I'll resend this patch to Andrew in hopes that he'll be okay with
having it in his tree until the next window.

Thanks!

