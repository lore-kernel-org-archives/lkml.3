Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbaGNOkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:40:33 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:37910 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbaGNOk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:40:26 -0400
Date: Mon, 14 Jul 2014 10:40:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] workqueue: remove the first check and the return
 value of maybe_create_worker()
Message-ID: <20140714144022.GC31610@htj.dyndns.org>
References: <1405008074-11031-1-git-send-email-laijs@cn.fujitsu.com>
 <1405008074-11031-2-git-send-email-laijs@cn.fujitsu.com>
 <20140711150327.GF27706@htj.dyndns.org>
 <53C340B3.5040209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C340B3.5040209@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:30:11AM +0800, Lai Jiangshan wrote:
> We already have create_worker(). And maybe_create_worker() does not always create worker.

Well, it does unless it fails.  Explicit maybe_ there is quite
misleading.

> maybe_create_worker() may not create worker if the condition is changed after
> it fails at the first time, 

It's misleading.  Please come up with a different name.

Thanks.

-- 
tejun
