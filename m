Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbbAFFz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 00:55:28 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38988 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbbAFFz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 00:55:26 -0500
Message-ID: <1420523722.5293.2.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH 0/3] sched: skip_clock_update madness
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Date: Tue, 06 Jan 2015 06:55:22 +0100
In-Reply-To: <20150105135942.GE29390@twins.programming.kicks-ass.net>
References: <20150105101809.860964488@infradead.org>
	 <1420454949.5266.138.camel@marge.simpson.net>
	 <20150105135942.GE29390@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 14:59 +0100, Peter Zijlstra wrote:

> OK, fair enough. Does the thing otherwise look sane to you?

Yup, should do the trick.

-Mike

