Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaAUL31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:29:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51866 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaAUL3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:29:23 -0500
Message-Id: <20140121111754.580142558@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 21 Jan 2014 12:17:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, daniel.lezcano@linaro.org, pjt@google.com,
        bsegall@google.com, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/9] Various sched patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A set of recent patches by Daniel reminded me of a series I did a while back.
So here's a combined set.

Paul, Ben, could you guys have a careful look at the one optimizing
pick_next_task_fair() (patch 8)? That patch is somewhat big and scary,
although it does appear to do what it says.

I've not yet tested the bandwidth aspect at all.

