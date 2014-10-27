Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaJ0Nsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:48:54 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:38132 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaJ0Nsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:48:53 -0400
Date: Mon, 27 Oct 2014 09:48:49 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Burke Libbey <burke.libbey@shopify.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: Re: [PATCH] sched: reset sched_entity depth on changing parent
Message-ID: <20141027134849.GH4436@htj.dyndns.org>
References: <20141024150746.GB25260@burke.local>
 <20141024155805.GF21513@worktop.programming.kicks-ass.net>
 <164441414171122@web11g.yandex.ru>
 <20141027120734.GA3337@twins.programming.kicks-ass.net>
 <20141027124002.GA4436@htj.dyndns.org>
 <20141027132812.GG3337@twins.programming.kicks-ass.net>
 <20141027134735.GG4436@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027134735.GG4436@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 09:47:35AM -0400, Tejun Heo wrote:
...
> cgroup migration is atomic against threadgroup changes - tasks joining
> or leaving the threadgroup.  If a process is forking a child, the
                                                              ^
							      process
-- 
tejun
