Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbaHUNwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:52:10 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33058 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbaHUNwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:52:08 -0400
Date: Thu, 21 Aug 2014 15:52:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH net-next 1/2] sched: introduce nr_running_this_cpu()
Message-ID: <20140821135203.GA29591@gmail.com>
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408608310-13579-1-git-send-email-jasowang@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Wang <jasowang@redhat.com> wrote:

> This patch introduces a helper nr_running_this_cpu() to return the
> number of runnable processes in current cpu.
> 
> The first user will be net rx busy polling. It will use this to exit
> the busy loop when it finds more than one processes is runnable in
> current cpu. This can give us better performance of busy polling under
> heavy load.

s/one processes/one process

More importantly, please Cc: scheduler maintainers and lkml to 
both patches, so that the whole intent of the change can be 
reviewed, in full context.

Thanks,

	Ingo
