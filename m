Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbaFSQ0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:26:13 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:35667 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757567AbaFSQ0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:26:12 -0400
Date: Thu, 19 Jun 2014 12:26:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: use schedule_timeout_interruptible() instead
 of open code
Message-ID: <20140619162609.GK26904@htj.dyndns.org>
References: <1401780737-12195-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401780737-12195-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 03:32:17PM +0800, Lai Jiangshan wrote:
> schedule_timeout_interruptible(CREATE_COOLDOWN) is exactly the same as
> the original code.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.17.

Thanks.

-- 
tejun
