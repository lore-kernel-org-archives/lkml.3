Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaFXWLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:11:53 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:59144 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaFXWLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:11:52 -0400
Date: Tue, 24 Jun 2014 18:11:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Jet Chen <jet.chen@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        LKP <lkp@01.org>
Subject: Re: [block, blk] BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000028
Message-ID: <20140624221148.GJ14909@htj.dyndns.org>
References: <53A8F812.5050006@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A8F812.5050006@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 12:01:22PM +0800, Jet Chen wrote:
> Hi Tejun,
> 
> we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-mq-percpu_ref
> commit c924ec35e72ce0d6c289b858d323f7eb3f5076a5 ("block, blk-mq: draining can't be skipped even if bypass_depth was non-zero")

Yeah, this is from trying to drain NULL root blkcg.  It's hit from
another path too and will soon be fixed.

Thanks!

-- 
tejun
