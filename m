Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaHZSRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:17:55 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:59730 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbaHZSRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:17:53 -0400
Date: Tue, 26 Aug 2014 14:17:49 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/35] percpu: Consistent per cpu operations V7
Message-ID: <20140826181749.GQ31659@mtj.dyndns.org>
References: <20140817173023.439660246@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817173023.439660246@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1-33 applied to percpu/for-3.18-consistent-ops.  Will wait for the
updated patches for the cpumask_var_t issue.

Thanks.

-- 
tejun
