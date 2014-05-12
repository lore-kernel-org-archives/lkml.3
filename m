Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaELSBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:01:38 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:40184 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaELSBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:01:37 -0400
Date: Mon, 12 May 2014 14:01:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] kernel/workqueue.c: pr_warning/pr_warn &
 printk/pr_info
Message-ID: <20140512180134.GF1421@htj.dyndns.org>
References: <20140512195623.bedc6e41683596d8d3b486c7@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512195623.bedc6e41683596d8d3b486c7@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 07:56:23PM +0200, Fabian Frederick wrote:
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied to wq/for-3.16.  Patch didn't apply and refreshed.  Please
consider basing further patches on top of subsystem devel branches.

Thanks.

-- 
tejun
