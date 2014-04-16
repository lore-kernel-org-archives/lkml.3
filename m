Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbaDPUu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:50:57 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:62640 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbaDPUuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:50:51 -0400
Date: Wed, 16 Apr 2014 16:50:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: add __WQ_FREEZING and remove POOL_FREEZING
Message-ID: <20140416205048.GD26632@htj.dyndns.org>
References: <20130421012925.GA19097@mtj.dyndns.org>
 <1395741364-19489-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395741364-19489-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 05:56:04PM +0800, Lai Jiangshan wrote:
> +	__WQ_FREEZING		= 1 << 15, /* internel: workqueue is freezing */
>  	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
>  	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */

Ooh, and please use bit 18, not 15.  The intention here is using bits
>= 16 for internal flags.

Thanks.

-- 
tejun
