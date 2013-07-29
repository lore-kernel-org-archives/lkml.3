Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3G2S5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:57:35 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:58445 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab3G2S5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:57:33 -0400
Message-ID: <51F6BB3D.6000700@gmail.com>
Date: Mon, 29 Jul 2013 14:58:05 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        azurIt <azurit@pobox.sk>, linux-mm@kvack.org, cgroups@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com
Subject: Re: [patch 2/6] arch: mm: do not invoke OOM killer on kernel fault
 OOM
References: <1374791138-15665-1-git-send-email-hannes@cmpxchg.org> <1374791138-15665-3-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1374791138-15665-3-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(7/25/13 6:25 PM), Johannes Weiner wrote:
> Kernel faults are expected to handle OOM conditions gracefully (gup,
> uaccess etc.), so they should never invoke the OOM killer.  Reserve
> this for faults triggered in user context when it is the only option.
> 
> Most architectures already do this, fix up the remaining few.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

OK. but now almost all arch have the same page fault handler. So, I think
we can implement arch generic page fault handler in future. Ah, ok, never
mind if you are not interest.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

