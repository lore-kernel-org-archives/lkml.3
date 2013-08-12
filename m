Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3HLBrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 21:47:53 -0400
Received: from one.firstfloor.org ([193.170.194.197]:37302 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab3HLBru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 21:47:50 -0400
Date: Mon, 12 Aug 2013 03:47:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Karim Yaghmour <karim.yaghmour@opersys.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu
Subject: Re: Reading perf counters at ftrace trace boundaries
Message-ID: <20130812014748.GP19750@two.firstfloor.org>
References: <5208263D.2080205@opersys.com>
 <87haevog75.fsf@tassilo.jf.intel.com>
 <52083CB4.2030308@opersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52083CB4.2030308@opersys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Indeed. It doesn't actually have to be at every single ftrace
> begin/exit. But possibly starting with some kind of every nth and then
> drilling down as the culprit is incrementally singled-out.

That's what normal sampling already does.

If you're worried about systematic shadow effects just randomize a bit.

-Andi
