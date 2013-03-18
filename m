Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3CRTvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:51:40 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:43974 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab3CRTvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:51:39 -0400
Date: Mon, 18 Mar 2013 12:51:36 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com
Subject: Re: [PATCHSET wq/for-3.10] workqueue: break up workqueue_lock into
 multiple locks
Message-ID: <20130318195136.GG3042@htj.dyndns.org>
References: <1363229845-6831-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363229845-6831-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 07:57:18PM -0700, Tejun Heo wrote:
> and available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-finer-locking

Applied to wq/for-3.10.

Thanks.

-- 
tejun
