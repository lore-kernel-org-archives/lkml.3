Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbaG3DqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:46:11 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:34468 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbaG3DqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:46:09 -0400
Date: Tue, 29 Jul 2014 23:46:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2 V2] workqueue: use dedicated creater kthread for
 all pools
Message-ID: <20140730034606.GB15787@htj.dyndns.org>
References: <20140729021643.GA22241@mtj.dyndns.org>
 <1406625376-19177-1-git-send-email-laijs@cn.fujitsu.com>
 <20140729150459.GE4791@htj.dyndns.org>
 <53D83D33.80101@cn.fujitsu.com>
 <20140730032334.GA15787@htj.dyndns.org>
 <53D86A7A.9080501@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D86A7A.9080501@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:46:02AM +0800, Lai Jiangshan wrote:
> It add complexity to other things but not the code.  The code is simplified.

How?  It can simply repeat kthread_create() until it succeeds with
msleep() inbetween.  How can that be more complex than what's
implemented now?

> And failed pool is much fewer than creation which is completely coincidental,
> and after cooldown time, the other pool may also create worker.

I don't follow the above at all.  Can you please elaborate?

Thanks.

-- 
tejun
