Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab3JOSWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:22:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35420 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab3JOSWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:22:45 -0400
Date: Tue, 15 Oct 2013 12:22:40 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 06/10] block: Replace __get_cpu_var uses
Message-ID: <20131015182240.GA541@kernel.dk>
References: <20131015175852.122827685@linux.com>
 <20131015180052.699083354@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015180052.699083354@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15 2013, Christoph Lameter wrote:
> __get_cpu_var() is used for multiple purposes in the kernel source. One of
> them is address calculation via the form &__get_cpu_var(x).  This calculates
> the address for the instance of the percpu variable of the current processor
> based on an offset.

Thanks, applied to for-3.13/core

-- 
Jens Axboe

