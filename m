Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaGAFlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 01:41:12 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:44127 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaGAFlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 01:41:11 -0400
Message-ID: <1404193267.5159.28.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 01 Jul 2014 07:41:07 +0200
In-Reply-To: <53B223AE.10903@linux.vnet.ibm.com>
References: <53A11A89.5000602@linux.vnet.ibm.com>
	 <53B11387.9020001@linux.vnet.ibm.com>
	 <1404115601.5132.156.camel@marge.simpson.net>
	 <53B12417.9060904@linux.vnet.ibm.com>
	 <1404120453.5132.194.camel@marge.simpson.net>
	 <53B223AE.10903@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-01 at 10:57 +0800, Michael wang wrote:

> IMHO, currently the generic scheduler just try to take care both latency
> and throughput, both will take a little damage but won't be damaged too
> much, they just sacrificed for each other...

The cost can be large, so it's worth an occasional ponder.

-Mike

