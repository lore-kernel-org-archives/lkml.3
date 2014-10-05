Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaJETsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 15:48:16 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:45990 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaJETsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 15:48:12 -0400
Date: Sun, 5 Oct 2014 15:48:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, jiri@resnulli.us
Subject: Re: [PATCH v2 2/2] workqueue: use cond_resched_rcu_qs macro
Message-ID: <20141005194809.GH8549@htj.dyndns.org>
References: <1412529862-17954-1-git-send-email-joe.lawrence@stratus.com>
 <1412529862-17954-3-git-send-email-joe.lawrence@stratus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412529862-17954-3-git-send-email-joe.lawrence@stratus.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 01:24:22PM -0400, Joe Lawrence wrote:
> Tidy up and use cond_resched_rcu_qs when calling cond_resched and
> reporting potential quiescent state to RCU.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>

Please route through the rcu tree.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
