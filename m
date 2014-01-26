Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaAZODk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 09:03:40 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33624 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaAZODj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 09:03:39 -0500
MIME-Version: 1.0
In-Reply-To: <20140126135444.GR9772@phenom.ffwll.local>
References: <1390316872-15887-1-git-send-email-chris@chris-wilson.co.uk>
	<1390739073-4519-1-git-send-email-chris@chris-wilson.co.uk>
	<20140126135444.GR9772@phenom.ffwll.local>
Date: Sun, 26 Jan 2014 06:03:38 -0800
Message-ID: <CANN689GDsXunNZAkkv7=CS2ct5m2WNqEODrn2jrvmd99jWDCAw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] lib: Export interval_tree
From: Michel Lespinasse <walken@google.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 5:54 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Sun, Jan 26, 2014 at 12:24:33PM +0000, Chris Wilson wrote:
>>  INTERVAL_TREE_DEFINE(struct interval_tree_node, rb,
>>                    unsigned long, __subtree_last,
>>                    START, LAST,, interval_tree)
>> +
>> +EXPORT_SYMBOL(interval_tree_insert);
>> +EXPORT_SYMBOL(interval_tree_remove);
>> +EXPORT_SYMBOL(interval_tree_iter_first);
>> +EXPORT_SYMBOL(interval_tree_iter_next);
>
> Hm, I've thought kernel coding style nowadays is to put the EXPORT_SYMBOL
> right below the definition of the function?

INTERVAL_TREE_DEFINE generates the definitions of these functions.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
