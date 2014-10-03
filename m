Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaJCSPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 14:15:33 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:62953 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaJCSP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:15:29 -0400
MIME-Version: 1.0
In-Reply-To: <1412356087-16115-2-git-send-email-aarcange@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
	<1412356087-16115-2-git-send-email-aarcange@redhat.com>
Date: Fri, 3 Oct 2014 11:15:28 -0700
X-Google-Sender-Auth: pyMR1Z_4nWVkDIXWbSUXTeh5SG8
Message-ID: <CA+55aFwEO9=ieSb0uipfQ+qP9nP1ps=NCTe0HL9arK1cRYaJPg@mail.gmail.com>
Subject: Re: [PATCH 01/17] mm: gup: add FOLL_TRIED
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: qemu-devel@nongnu.org, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        "\\Dr. David Alan Gilbert\\" <dgilbert@redhat.com>,
        Christopher Covington <cov@codeaurora.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This needs more explanation than that one-liner comment. Make the
commit message explain why the new FOLL_TRIED flag exists.

      Linus

On Fri, Oct 3, 2014 at 10:07 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> From: Andres Lagar-Cavilla <andreslc@google.com>
>
> Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Andres Lagar-Cavilla <andreslc@google.com>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
