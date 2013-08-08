Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965971Ab3HHQMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 12:12:36 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:50463 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965213Ab3HHQMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 12:12:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLHCVER8MX=wbwqUTe+MfoxtAu-X3CtUA=9uFyz+q+XtsQ@mail.gmail.com>
References: <1375967992.6848.55.camel@gandalf.local.home>
	<CAOJsxLHCVER8MX=wbwqUTe+MfoxtAu-X3CtUA=9uFyz+q+XtsQ@mail.gmail.com>
Date: Thu, 8 Aug 2013 09:12:33 -0700
X-Google-Sender-Auth: zz_3V1YSYHkX_2_hm04ClK4fvBQ
Message-ID: <CA+55aFzdg0L6VfYsTz9HdqVwd-80u1cet7sTe7YnMtroXcxmRw@mail.gmail.com>
Subject: Re: [PATCH] Revert "slub: do not put a slab to cpu partial list when
 cpu_partial is 0"
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Christoph Lameeter <cl@linux.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 7:35 AM, Pekka Enberg <penberg@kernel.org> wrote:
>
> Linus, can you pick this up or do you want a pull request?

I just did the revert when reading the original thread, and hadn't
even gotten to this new email thread with an actual patch.

Anyway, it's reverted in my tree,

               Linus
