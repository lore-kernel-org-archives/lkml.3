Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab3CTS5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:57:19 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:37990 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab3CTS5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:57:17 -0400
Date: Wed, 20 Mar 2013 11:57:08 -0700
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCHSET wq/for-3.10] workqueue: NUMA affinity for unbound
 workqueues
Message-ID: <20130320185708.GB31256@htj.dyndns.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363737629-16745-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 05:00:19PM -0700, Tejun Heo wrote:
> and also available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-numa

Branch rebased on top of the current wq/for-3.10 with updated patches.
The new comit ID is 9555fbc12d786a9eae7cf7701a6718a0c029173e.

Thanks.

-- 
tejun
