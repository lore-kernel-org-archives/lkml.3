Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaIHWOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:14:33 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:61312 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbaIHWOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:14:32 -0400
Date: Tue, 9 Sep 2014 07:14:27 +0900
From: Tejun Heo <tj@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu: Resolve ambiguities in
 __get_cpu_var/cpumask_var_t -fix
Message-ID: <20140908221427.GA3806@mtj.dyndns.org>
References: <20140908220654.GO17501@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908220654.GO17501@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 11:06:54PM +0100, Mel Gorman wrote:
> A commit in linux-next was causing boot to fail and bisection identified
> the patch "percpu: Resolve ambiguities in __get_cpu_var/cpumask_var_".
> The commit ID is worthless as it's a linux-next commit. One of the changes

It is actually a stable commit ID.  I'll add the commit ID in the
change log.

> in that patch looks very suspicious. Reverting the full patch fixes boot
> as does this fixlet.

Applying to percpu/for-3.18-consistent-ops.

Thanks.

-- 
tejun
