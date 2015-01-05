Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbbAEKjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:39:07 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36805 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbbAEKhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:37:37 -0500
Message-Id: <20150105101809.860964488@infradead.org>
User-Agent: quilt/0.61-1
Date: Mon, 05 Jan 2015 11:18:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, umgwanakikbuti@gmail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        "Peter Zijlstra" <peterz@infradead.org>
Subject: [RFC][PATCH 0/3] sched: skip_clock_update madness
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So the big lockup thread got me looking at the skip_clock_update stuff again
and here's what I came up with.

It seems to build a kernel without generating lockdep splats.

Mike can you see if it cures the wobblies you were seeing?

