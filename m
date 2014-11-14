Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161027AbaKNNOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:14:53 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:38030 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960AbaKNNOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:14:52 -0500
Date: Fri, 14 Nov 2014 08:14:48 -0500
From: Tejun Heo <tj@kernel.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 09/16] percpu: Replace smp_read_barrier_depends() with
 lockless_dereference()
Message-ID: <20141114131448.GC21209@htj.dyndns.org>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
 <1415906662-4576-10-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415906662-4576-10-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 02:24:15PM -0500, Pranith Kumar wrote:
> Recently lockless_dereference() was added which can be used in place of
> hard-coding smp_read_barrier_depends(). The following PATCH makes the change.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

How should this be routed?  There's a pending change on the same
region of code and if this patch is routed outside percpu tree it'd
cause a conflict and I can't route this as lockless_dereference()
isn't in the mainline yet.  Maybe expose a git branch which contaisn
lockless_dereference() so that percpu can pull it in?

Thanks.

-- 
tejun
