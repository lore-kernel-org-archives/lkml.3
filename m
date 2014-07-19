Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbaGSLyk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 07:54:40 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:53280 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbaGSLyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 07:54:39 -0400
Date: Sat, 19 Jul 2014 13:54:32 +0200
From: Robert Richter <rric@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, oprofile-list@lists.sf.net
Subject: Re: [PATCH 07/31] drivers/oprofile: Replace __get_cpu_var uses for
 address calculation
Message-ID: <20140719115432.GU4703@rric.localhost>
References: <20140620193115.547427118@linux.com>
 <20140620193125.688151423@linux.com>
 <20140718232850.GN5739@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718232850.GN5739@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.07.14 19:28:50, Tejun Heo wrote:
> On Fri, Jun 20, 2014 at 02:31:22PM -0500, Christoph Lameter wrote:
> > Replace the uses of __get_cpu_var for address calculation with this_cpu_ptr.
> > 
> > Cc: Robert Richter <rric@kernel.org>
> > Cc: oprofile-list@lists.sf.net
> > Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Applied to wq/for-3.17-consistent-ops.  If this patch should be routed
> differently, please holler.

Fine with me. Thanks

-Robert
