Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab3J0NEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 09:04:20 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:50443 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab3J0NET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 09:04:19 -0400
Date: Sun, 27 Oct 2013 09:04:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] percpu: remove this_cpu_xor()
Message-ID: <20131027130415.GA30307@mtj.dyndns.org>
References: <1382354737-59872-1-git-send-email-heiko.carstens@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382354737-59872-1-git-send-email-heiko.carstens@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 01:25:35PM +0200, Heiko Carstens wrote:
> While optimizing and testing s390's this_cpu ops I realized that
> this_cpu_xor() generates broken code ("or" instead of "xor").
> 
> Since there is not a single user in the whole kernel tree it seems
> to be a good opportunity to simply remove it instead of fixing it.
> 
> These two patches only remove the generic and x86 variant. It doesn't
> touch s390 since it would only generate a merge conflict later on.
> I will take care of s390 anyway if the consensus is that it should be
> removed.
> 
> Heiko Carstens (2):
>   percpu: remove this_cpu_xor() implementation
>   x86: remove this_cpu_xor() implementation

Applied to percpu/for-3.13.

Thanks.

-- 
tejun
