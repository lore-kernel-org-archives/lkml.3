Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaAWSh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:37:58 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:42065 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaAWShz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:37:55 -0500
Message-ID: <1390502404.5567.994.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kmo@daterainc.com, target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>
Date: Thu, 23 Jan 2014 10:40:04 -0800
In-Reply-To: <1390420413.5567.949.camel@haakon3.risingtidesystems.com>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
	 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
	 <20140120113415.GE30183@twins.programming.kicks-ass.net>
	 <20140121221852.GT9037@kmo>
	 <1390420413.5567.949.camel@haakon3.risingtidesystems.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-22 at 11:53 -0800, Nicholas A. Bellinger wrote:
> Hi Peter,
> 
> Does this satisfy your questions..?
> 
> Do you have any more concerns about TASK_RUNNING + prepare_to_wait()
> usage in percpu_ida_alloc() that need to be addressed before I can drop
> this series into target-pending/for-next to address the original bug..?
> 

Given the silence, I'll assume your OK with the initial TASK_RUNNING +
prepare_to_wait() bit, right..?

--nab

