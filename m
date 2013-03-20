Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3CTSTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:19:41 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:35547 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab3CTSTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:19:40 -0400
Date: Wed, 20 Mar 2013 11:19:30 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/21] workqueue: read POOL_DISASSOCIATED bit under
 pool->lock
Message-ID: <20130320181930.GC30484@htj.dyndns.org>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
 <1363721306-2030-19-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363721306-2030-19-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 03:28:18AM +0800, Lai Jiangshan wrote:
> Simply move it to pool->lock C.S.

Patch description should explain *why* in addition to what.  Also,
please don't use abbreviations like C.S.  Yeah, I know it's critical
section but it might as well be counter strike or context switch.

Thanks.

-- 
tejun
