Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab3BRRDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:03:36 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:58226 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab3BRRDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:03:34 -0500
Date: Mon, 18 Feb 2013 09:03:30 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 2/2 wq/for-3.9] workqueue: reimplement is_chained_work()
 using current_wq_worker()
Message-ID: <20130218170330.GB17414@htj.dyndns.org>
References: <20130214032633.GF9057@htj.dyndns.org>
 <20130214032705.GG9057@htj.dyndns.org>
 <511FBCA0.9020205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511FBCA0.9020205@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Lai.

On Sun, Feb 17, 2013 at 01:06:40AM +0800, Lai Jiangshan wrote:
> Hi, tj
> 
> Thank you for adding this one.
> 
> Would you deffer "workqueue: rename cpu_workqueue to pool_workqueue"
> a little? I don't want to rebase my almost-ready work again(not a
> good reason... but please...)

Sorry about the late reply.  Was offline over the weekend.  I see that
you already updated your patches on top, so I suppose this doesn't
matter anymore?

Thanks!

-- 
tejun
