Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937041Ab3DJQUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:20:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933387Ab3DJQUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:20:15 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [RESEND][PATCH v5 0/3] fix hugepage coredump
Date: Wed, 10 Apr 2013 12:17:46 -0400
Message-Id: <1365610669-16625-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to add Reviewed/Acked. Please ignore my previous post.
Sorry for the noise.
-----
Hi,

Here is 5th version of hugepage coredump fix.
I changed the place to put swap entry check in 3/3,
and explained more in comment.

Thanks,
Naoya Horiguchi
