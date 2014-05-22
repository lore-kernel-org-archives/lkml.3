Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaEVPjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:39:45 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:37358 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaEVPjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:39:43 -0400
Date: Thu, 22 May 2014 11:39:38 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: remove unused work_clear_pending()
Message-ID: <20140522153938.GD5065@htj.dyndns.org>
References: <1400748236-14097-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400748236-14097-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 04:43:56PM +0800, Lai Jiangshan wrote:
> In 8930caba, setting last CPU and clearing PENDING got merged into a single

Ditto.

> operation (set_work_cpu_and_clear_pending()), which resulted that the
> internal routine work_clear_pending() is not used any more.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.16.

Thanks.

-- 
tejun
