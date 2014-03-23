Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbaCWUVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 16:21:43 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:56559 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaCWUVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 16:21:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140323122913.GC2813@quack.suse.cz>
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org>
	<1395436655-21670-3-git-send-email-john.stultz@linaro.org>
	<20140323122913.GC2813@quack.suse.cz>
Date: Sun, 23 Mar 2014 13:21:41 -0700
Message-ID: <CALAqxLVHrtDOtfkPUDgzwdt6eOG4rdykJq6zBFZmRWq+H7i3uA@mail.gmail.com>
Subject: Re: [PATCH 2/5] vrange: Add purged page detection on setting memory non-volatile
From: John Stultz <john.stultz@linaro.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 5:29 AM, Jan Kara <jack@suse.cz> wrote:
> On Fri 21-03-14 14:17:32, John Stultz wrote:
>> + *
>> + * Sets the vrange_walker.pages_purged to 1 if any were purged.
>                               ^^^ page_was_purged

Doh. Thanks for catching this! Fixed in my tree.

Thanks so much for the review!
-john
