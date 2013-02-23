Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab3BWHeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 02:34:23 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:41103 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab3BWHeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 02:34:20 -0500
MIME-Version: 1.0
Date: Sat, 23 Feb 2013 15:34:17 +0800
Message-ID: <CAJd=RBBwwjiBcfCe5wMSS8Dzz1tF=EfGsGMggH+A174yTKa9PA@mail.gmail.com>
Subject: Are there numa balancing topics scheduled for the incoming LSF?
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all

On Mon, Dec 17, 2012 at 7:19 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Dec 12, 2012 at 2:03 AM, Mel Gorman <mgorman@suse.de> wrote:
>> This is a pull request for "Automatic NUMA Balancing V11". The list
>
> Ok, guys, I've pulled this and pushed out. There were some conflicts
> with both the VM changes and with the scheduler tree, but they were
> pretty small and looked simple, so I fixed them up and hope they all
> work.
>
> Anyway, hopefully we'll have a more real numa balancing for 3.9, and
> this is still considered a reasonable base for that work.
>
And what is scheduled for 3.9?

Thanks
Hillf
