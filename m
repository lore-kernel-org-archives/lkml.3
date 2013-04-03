Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763406Ab3DCKNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 06:13:05 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58101 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759876Ab3DCKNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 06:13:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAHO5Pa0srsWS6ukpxUo=EqCOxRmYa7c_7PDg1YPh7gcMGWPpaw@mail.gmail.com>
References: <1364192494-22185-1-git-send-email-minchan@kernel.org> <CAHO5Pa0srsWS6ukpxUo=EqCOxRmYa7c_7PDg1YPh7gcMGWPpaw@mail.gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Wed, 3 Apr 2013 12:12:42 +0200
X-Google-Sender-Auth: yCaXJy2cqLjGU9TSdYfH09sWkPU
Message-ID: <CAHO5Pa1we3FCoBTSHTO23tzCss4Z-AkZzoGxBYkTy7e5aYmcJw@mail.gmail.com>
Subject: Re: [RFC 1/4] mm: Per process reclaim
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Sangseok Lee <sangseok.lee@lge.com>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, the interface is a quite blunt instrument. Would there be any
> virtue in extending it so that an address range could be written to

Here, I did mean to say "an *optional* address range.

Thanks,

Michael
