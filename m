Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab3GZDHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:07:22 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:51804 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab3GZDHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:07:18 -0400
Date: Thu, 25 Jul 2013 23:07:11 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: clear workers of a pool after the CPU is
 offline
Message-ID: <20130726030711.GA30195@mtj.dyndns.org>
References: <1374749531-16423-1-git-send-email-laijs@cn.fujitsu.com>
 <20130725153121.GF26107@mtj.dyndns.org>
 <51F1DB45.90905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F1DB45.90905@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jul 26, 2013 at 10:13:25AM +0800, Lai Jiangshan wrote:
> > Hmmm... if I'm not confused, now the cpu pools just behave like a
> > normal unbound pool when the cpu goes down,
> 
> cpu pools are always referenced, they don't behave like unbound pool.

Yeah sure, they don't get destroyed but pool management functions the
same.

> > which means that the idle
> > cpu workers will exit once idle timeout is reached, right? 
> 
> No, no code to force the cpu workers quit currently.
> you can just offline a cpu to see what happened to the workers.

Hmmm?  The idle timer thing doesn't work?  Why?

-- 
tejun
