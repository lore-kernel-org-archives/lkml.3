Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab3LKKgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:36:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52019 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3LKKgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:36:42 -0500
Date: Wed, 11 Dec 2013 11:36:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: andi@firstfloor.org, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: perf: hsw model numbers
Message-ID: <20131211103631.GJ13532@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

arch/x86/kernel/cpu/perf_event_intel.c

3a632cb229bfb (Andi Kleen       2013-06-17 17:36:48 -0700 2500)         case 60: /* Haswell Client */
3a632cb229bfb (Andi Kleen       2013-06-17 17:36:48 -0700 2501)         case 70:
3a632cb229bfb (Andi Kleen       2013-06-17 17:36:48 -0700 2502)         case 71:
3a632cb229bfb (Andi Kleen       2013-06-17 17:36:48 -0700 2503)         case 63:
0499bd867bd17 (Andi Kleen       2013-08-08 17:26:23 -0700 2504)         case 69:

Can you add comments with each model number describing what actual part
it is?

Also, we seem to lack snb/ivb EX part numbers, are those already known?
