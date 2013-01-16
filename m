Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab3APWEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:04:41 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:41056 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab3APWEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:04:40 -0500
MIME-Version: 1.0
In-Reply-To: <50F72272.8090303@oracle.com>
References: <1358094677-11384-1-git-send-email-sasha.levin@oracle.com>
 <CA+55aFxFb21Ss=-0FUgzQOzPe1=mS11o7J-+Laco09XJvOk9Fg@mail.gmail.com> <50F72272.8090303@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Jan 2013 14:04:19 -0800
X-Google-Sender-Auth: 4x1afF7BPm28VNi4alXPL5lMKYI
Message-ID: <CA+55aFxjwW4Ppv-73WHh-RqeFvq+Bjr3o08ZuKkiWuwAVMkqFQ@mail.gmail.com>
Subject: Re: [PATCH v2] hlist: drop the node parameter from iterators
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 1:58 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> I guess that if you agree that it should go in once it had some more
> testing, it can go into linux-next and sit there for the next couple
> of weeks until the next merge window opens.

So linux-next gets compile testing and warns about conflicts. But
almost nobody really runs the end result.

Now, *hopefully* the compile problems and conflicts are the major
issue, but at the same time, I worry about some actual subtle semantic
breakage. I'm not sure how it would happen, but it's a big patch..

> What would be the best way to do that though? see if akpm would take
> it into his tree?

That would help. As would just linux-next. As would just after the
next merge window closes, if you can send it almost immediately *and*
have the "at least the patch has been around for a long time with no
*known* breakage" note. Because at some point, I guess we can't do
much more than that.

                Linus
