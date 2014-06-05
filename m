Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaFEBRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:17:34 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:53852 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbaFEBRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:17:33 -0400
Date: Wed, 4 Jun 2014 21:17:29 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: use "pool->cpu < 0" to stand for an unbound
 pool
Message-ID: <20140605011729.GA14370@mtj.dyndns.org>
References: <1401780714-12127-1-git-send-email-laijs@cn.fujitsu.com>
 <538FC5F8.1020605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538FC5F8.1020605@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 09:20:56AM +0800, Lai Jiangshan wrote:
> And would these patches be possible for 3.16?

It's a bit too late.  I'd like to wait for the next merge window.
AFAICS, there's nothing critical, right?

Thanks.

-- 
tejun
