Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaIDQtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:49:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52854 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaIDQtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:49:51 -0400
Date: Thu, 4 Sep 2014 18:49:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: mingo@redhat.com, Kirill Tkhai <tkhai@yandex.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>
Subject: Re: [RFC] smt-aware rt load balancer
Message-ID: <20140904164948.GI346@worktop.programming.kicks-ass.net>
References: <77161409833206@webcorp01h.yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77161409833206@webcorp01h.yandex-team.ru>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No, we're not going to merge a second rt balancer. If you want to change
it change the one that is there. But it needs to remain a valid
_Real_Time_ balancer at all times.
