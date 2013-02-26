Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab3BZFAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:00:22 -0500
Received: from 216-139-250-139.aus.us.siteprotect.com ([216.139.250.139]:56597
	"EHLO joe.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3BZFAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:00:21 -0500
Date: Mon, 25 Feb 2013 21:00:21 -0800 (PST)
From: yqzhang <yqzhang@ucsd.edu>
To: linux-kernel@vger.kernel.org
Message-ID: <1361854821579-606450.post@n7.nabble.com>
In-Reply-To: <1361355312-3323-1-git-send-email-eranian@google.com>
References: <1361355312-3323-1-git-send-email-eranian@google.com>
Subject: Re: [PATCH] perf, x86: add Intel IvyBridge event scheduling
 constraints
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

I was wondering what the differences are between
CYCLE_ACTIVITY.CYCLES_**_PENDING and CYCLE_ACTIVITY.STALLS_**_PENDING,
because I could only find following events in the SDM, which seem to be
different from the ones provided here. Correct me if I'm wrong.

A3H 01H CYCLE_ACTIVITY.CYCLES_L2_PENDING
  - Cycles with pending L2 miss loads. Set Cmask=2 tocount cycle. Use only
when HTT is off
A3H 02H CYCLE_ACTIVITY.CYCLES_LDM_PENDING
  - Cycles with pending memory loads. Set Cmask=2 to count cycle.
A3H 05H CYCLE_ACTIVITY.STALLS_L2_PENDING
  - Number of loads missed L2. Use only when HTT is off
A3H 08H CYCLE_ACTIVITY.CYCLES_L1D_PENDING
  - Cycles with pending L1 cache miss loads. SetCmask=8 to count cycle.PMC2
only

Thanks a lot!



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/PATCH-perf-x86-add-Intel-IvyBridge-event-scheduling-constraints-tp604032p606450.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
