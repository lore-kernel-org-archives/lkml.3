Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030880AbaGRXdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:33:54 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:42233 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030258AbaGRXdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:33:52 -0400
Date: Fri, 18 Jul 2014 19:33:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH 29/31] avr32: Replace __get_cpu_var with __this_cpu_write
Message-ID: <20140718233348.GH5739@htj.dyndns.org>
References: <20140620193115.547427118@linux.com>
 <20140620193128.347401329@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620193128.347401329@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:31:44PM -0500, Christoph Lameter wrote:
> Replace the single use of __get_cpu_var in avr32 with
> __this_cpu_write.
> 
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to wq/for-3.17-consistent-ops.  If this patch should be routed
differently, please holler.

Thanks.

-- 
tejun
