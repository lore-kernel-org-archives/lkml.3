Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab3G3SNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:13:50 -0400
Received: from relay2.sgi.com ([192.48.179.30]:57729 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752800Ab3G3SNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:13:49 -0400
Date: Tue, 30 Jul 2013 13:13:45 -0500
From: Ben Myers <bpm@sgi.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        Alex Elder <elder@kernel.org>, shli@kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 7/9] xfs: WQ_NON_REENTRANT is meaningless and going away
Message-ID: <20130730181345.GO3111@sgi.com>
References: <1375188028-11910-1-git-send-email-tj@kernel.org>
 <1375188028-11910-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375188028-11910-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, Jul 30, 2013 at 08:40:26AM -0400, Tejun Heo wrote:
> Hello,
> 
> Please route this through the subsystem tree.  As written in the
> description, this shouldn't make any functional difference and just
> prepares for the removal of WQ_NON_REENTRANT which is already noop.
> 
> Thanks.
>
> ------ 8< -------
> dbf2576e37 ("workqueue: make all workqueues non-reentrant") made
> WQ_NON_REENTRANT no-op and the flag is going away.  Remove its usages.
> 
> This patch doesn't introduce any behavior changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: xfs@oss.sgi.com

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.
