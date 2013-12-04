Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab3LDQwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:52:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53578 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057Ab3LDQwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:52:39 -0500
Message-ID: <529F5D98.1050003@kernel.dk>
Date: Wed, 04 Dec 2013 09:51:36 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 21/41] block: Replace __this_cpu_ptr with raw_cpu_ptr
References: <20131203233232.928771708@linux.com> <20131203233255.999121189@linux.com> <20131204022016.GE5051@kernel.dk> <00000142be798592-db9e5e34-8889-415f-8329-1ca7e6fde9fd-000000@email.amazonses.com>
In-Reply-To: <00000142be798592-db9e5e34-8889-415f-8329-1ca7e6fde9fd-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 09:38 AM, Christoph Lameter wrote:
> On Tue, 3 Dec 2013, Jens Axboe wrote:
> 
>> Christoph, I applied the fs/buffer.c bit, the ext4 one should probably
>> go through Ted.
> 
> This is not going to work unless earlier patchses have been applied since
> raw_cpu_ptr is otherwise not availab.e

Overnigh caught that too. You might want to make such requirements
explicit in the patch, when sending it out...

-- 
Jens Axboe

