Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3APUtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 15:49:12 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:64342 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab3APUtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 15:49:11 -0500
MIME-Version: 1.0
In-Reply-To: <1358094677-11384-1-git-send-email-sasha.levin@oracle.com>
References: <1358094677-11384-1-git-send-email-sasha.levin@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Jan 2013 12:48:48 -0800
X-Google-Sender-Auth: CBCw7xfvEooYrTFsY756IRwUMRk
Message-ID: <CA+55aFxFb21Ss=-0FUgzQOzPe1=mS11o7J-+Laco09XJvOk9Fg@mail.gmail.com>
Subject: Re: [PATCH v2] hlist: drop the node parameter from iterators
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 8:31 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> I'm not sure why, but the hlist for each entry iterators were conceived
> differently from the list ones. While the list ones are nice and elegant:

So this patch is probably the RightThing(tm) to do, but it's really
big and makes me nervous. And the fact that there was already one
problem in the first version doesn't make me feel any more
warm-and-fuzzy about it.

I understand that this kind of patch is nice to apply after the merge
window has closed, but at the same time, it's now *too* long after the
merge window closed, and even if it wasn't, I'd really like to feel
like this has gotten more testing than it obviously has. Or some other
guarantee that there isn't some other subtle issue hiding there.

So I am going through patches in my mbox, but I really don't feel safe
enough about this one to apply it.

                    Linus
