Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965424Ab3HHOfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:35:40 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:62073 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934262Ab3HHOfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:35:39 -0400
MIME-Version: 1.0
In-Reply-To: <1375967992.6848.55.camel@gandalf.local.home>
References: <1375967992.6848.55.camel@gandalf.local.home>
Date: Thu, 8 Aug 2013 17:35:38 +0300
X-Google-Sender-Auth: FwTy_-rPS-RmBnERvALj0lWBw2Y
Message-ID: <CAOJsxLHCVER8MX=wbwqUTe+MfoxtAu-X3CtUA=9uFyz+q+XtsQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "slub: do not put a slab to cpu partial list when
 cpu_partial is 0"
From: Pekka Enberg <penberg@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Christoph Lameeter <cl@linux.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 4:19 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> This reverts commit 318df36e57c0ca9f2146660d41ff28e8650af423

[snip]

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Pekka Enberg <penberg@kernel.org>

Linus, can you pick this up or do you want a pull request?

                       Pekka
