Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaEJDyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 23:54:55 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:33754 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaEJDyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 23:54:54 -0400
Message-ID: <1399694090.5146.13.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: wake up task on prev_cpu if not in
 SD_WAKE_AFFINE domain with cpu
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com, mingo@kernel.org,
        george.mccollister@gmail.com, ktkhai@parallels.com
Date: Sat, 10 May 2014 05:54:50 +0200
In-Reply-To: <536D1B6D.8060004@redhat.com>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
	 <1399011219.5233.55.camel@marge.simpson.net> <53633B81.1080403@redhat.com>
	 <1399016273.5233.94.camel@marge.simpson.net> <536379D0.8070306@redhat.com>
	 <1399030032.5233.142.camel@marge.simpson.net> <5363B793.9010208@redhat.com>
	 <20140506115448.GH11096@twins.programming.kicks-ass.net>
	 <536943C9.4030502@redhat.com>
	 <20140506203916.GQ17778@laptop.programming.kicks-ass.net>
	 <536C3B69.1000208@redhat.com>
	 <20140509012743.67d4006d@annuminas.surriel.com>
	 <1399620873.5200.68.camel@marge.simpson.net> <536CE48E.2060305@redhat.com>
	 <1399649042.31219.47.camel@marge.simpson.net> <536CF346.6080009@redhat.com>
	 <1399658123.5187.2.camel@marge.simpson.net> <536D1B6D.8060004@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 14:16 -0400, Rik van Riel wrote:

> That leaves the big question: do we want to fall back to
> prev_cpu if it is not idle, and it has an idle sibling,
> or would it be better to find an idle sibling of prev_cpu
> when we wake up a task?

Yes.  If there was A correct answer, this stuff would be a lot easier.

-Mike

