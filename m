Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbaIDRGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:06:34 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:36865 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838AbaIDRGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:06:32 -0400
From: Roman Gushchin <klamm@yandex-team.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mingo@redhat.com" <mingo@redhat.com>, Kirill Tkhai <tkhai@yandex.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>
In-Reply-To: <20140904164948.GI346@worktop.programming.kicks-ass.net>
References: <77161409833206@webcorp01h.yandex-team.ru> <20140904164948.GI346@worktop.programming.kicks-ass.net>
Subject: Re: [RFC] smt-aware rt load balancer
MIME-Version: 1.0
Message-Id: <294761409850387@webcorp02f.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 04 Sep 2014 21:06:27 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not pretending to merge it now (and that why I sent a link to repository instead of patches), but,
probably, there are guys here, who can try it and save a bit of hardware.

Regards,
Roman


04.09.2014, 20:49, "Peter Zijlstra" <peterz@infradead.org>:
> No, we're not going to merge a second rt balancer. If you want to change
> it change the one that is there. But it needs to remain a valid
> _Real_Time_ balancer at all times.
