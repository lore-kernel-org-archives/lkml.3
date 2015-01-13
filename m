Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbbAMT0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:26:39 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:52589 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbbAMT0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:26:37 -0500
MIME-Version: 1.0
In-Reply-To: <1421167074-9789-1-git-send-email-aarcange@redhat.com>
References: <1421167074-9789-1-git-send-email-aarcange@redhat.com>
Date: Tue, 13 Jan 2015 11:26:36 -0800
Message-ID: <CAJu=L58eMD6yfdo3rKZ_QhSVyQkjKQOpTiboDsmcefYj=0rwYQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] leverage FAULT_FOLL_ALLOW_RETRY in get_user_pages try#2
From: Andres Lagar-Cavilla <andreslc@google.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Michel Lespinasse <walken@google.com>,
        Andrew Jones <drjones@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "\\Dr. David Alan Gilbert\\" <dgilbert@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        David Miller <davem@davemloft.net>,
        Steve Capper <steve.capper@linaro.org>,
        Johannes Weiner <jweiner@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 8:37 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> Last submit didn't go into -mm/3.19-rc, no prob but here I retry
> (possibly too early for 3.20-rc but I don't expect breakages in this
> area post -rc4) after a rebase on upstream.

The series looks good to me, I didn't spot any material changes from last time.

I would fold patches 3 & 4 together: it's the same idea behind both,
just different parts of the tree.

You could argue also for folding 1 &2 together, the "damage" is done
in 1, 2 as a standalone results in an (IMHO) unnecessarily large diff.

Thanks,
Andres


------ 8< snipping the rest ---------------
