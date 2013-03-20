Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab3CTSBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:01:33 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:49742 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab3CTSBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:01:32 -0400
Date: Wed, 20 Mar 2013 11:01:26 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/21] workqueue: use rcu_read_lock_sched() instead for
 accessing pwq in RCU
Message-ID: <20130320180126.GC29523@htj.dyndns.org>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
 <1363721306-2030-11-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363721306-2030-11-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 03:28:10AM +0800, Lai Jiangshan wrote:
> rcu_read_lock_sched() is better than preempt_disable() if the code is
> protected by RCU_SCHED.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.10.

Thanks.

-- 
tejun
