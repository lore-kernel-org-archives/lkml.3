Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaEVPjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:39:24 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:52782 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaEVPjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:39:22 -0400
Date: Thu, 22 May 2014 11:39:18 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: remove unused WORK_CPU_END
Message-ID: <20140522153918.GC5065@htj.dyndns.org>
References: <1400748224-14063-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400748224-14063-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 04:43:44PM +0800, Lai Jiangshan wrote:
> WORK_CPU_END is totally unused since 4e8b22bd. It should be removed.

Please use 12_CHAR_PREFIX_OF_SHA1 ("SUBJ") when referring to other
commits.

> After it is removed, the comment "special cpu IDs" is not precise due to
> there is only one special CPU ID (WORK_CPU_UNBOUND) left, so we also
> change this comment to the description for WORK_CPU_UNBOUND.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.16.

Thanks.

-- 
tejun
