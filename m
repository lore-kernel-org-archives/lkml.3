Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab3LDQi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:38:26 -0500
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:47661 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755669Ab3LDQiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:38:25 -0500
Date: Wed, 4 Dec 2013 16:38:24 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jens Axboe <axboe@kernel.dk>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 21/41] block: Replace __this_cpu_ptr with raw_cpu_ptr
In-Reply-To: <20131204022016.GE5051@kernel.dk>
Message-ID: <00000142be798592-db9e5e34-8889-415f-8329-1ca7e6fde9fd-000000@email.amazonses.com>
References: <20131203233232.928771708@linux.com> <20131203233255.999121189@linux.com> <20131204022016.GE5051@kernel.dk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.04-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Jens Axboe wrote:

> Christoph, I applied the fs/buffer.c bit, the ext4 one should probably
> go through Ted.

This is not going to work unless earlier patchses have been applied since
raw_cpu_ptr is otherwise not availab.e

