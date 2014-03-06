Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaCFP5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:57:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58534 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaCFP5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:57:38 -0500
Date: Thu, 6 Mar 2014 16:57:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH tip] [PATCH]sched/fair: Fix endless loop in idle_balance()
Message-ID: <20140306155731.GP9987@twins.programming.kicks-ass.net>
References: <1394118975.19290.104.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394118975.19290.104.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 07:16:15PM +0400, Kirill Tkhai wrote:
> Peter, this finaly fixes problem with RT throttling.
> Should I send all three patches as one series?

No need; got them. Thanks!
