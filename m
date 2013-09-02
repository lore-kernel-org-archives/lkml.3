Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab3IBGzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 02:55:21 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:34211 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab3IBGzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 02:55:15 -0400
Date: Mon, 2 Sep 2013 08:55:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, acme@infradead.org,
        jolsa@redhat.com, eranian@google.com
Subject: Re: perf, x86: Add parts of the remaining haswell PMU functionality
Message-ID: <20130902065512.GA29060@gmail.com>
References: <1376010946-28666-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376010946-28666-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One thing I'm not seeing in the current Haswell code is the config set up 
for PERF_COUNT_HW_STALLED_CYCLES_FRONTEND/BACKEND. Both SB and IB has them 
configured.

Thanks,

	Ingo
