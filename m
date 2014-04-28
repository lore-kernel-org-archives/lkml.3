Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbaD1Pq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:46:56 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:34378 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755968AbaD1Pqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:46:53 -0400
From: Roman Gushchin <klamm@yandex-team.ru>
To: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
Subject: Re: [PATCH v2 0/4] memcg: Low-limit reclaim
MIME-Version: 1.0
Message-Id: <10861398700008@webcorp2f.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 28 Apr 2014 19:46:48 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

28.04.2014, 16:27, "Michal Hocko" <mhocko@suse.cz>:
> The series is based on top of the current mmotm tree. Once the series
> gets accepted I will post a patch which will mark the soft limit as
> deprecated with a note that it will be eventually dropped. Let me know
> if you would prefer to have such a patch a part of the series.
>
> Thoughts?


Looks good to me.

The only question is: are there any ideas how the hierarchy support
will be used in this case in practice?
Will someone set low limit for non-leaf cgroups? Why?

Thanks,
Roman
