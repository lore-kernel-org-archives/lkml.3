Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab3ENSsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:48:42 -0400
Received: from mail-gh0-f177.google.com ([209.85.160.177]:47713 "EHLO
	mail-gh0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab3ENSsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:48:41 -0400
X-Greylist: delayed 1983 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 May 2013 14:48:40 EDT
Date: Tue, 14 May 2013 11:48:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH for-3.10] workqueue: correct handling of the pool
 spin_lock
Message-ID: <20130514184835.GQ6795@mtj.dyndns.org>
References: <1367334420-4331-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367334420-4331-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 12:07:00AM +0900, Joonsoo Kim wrote:
> When we fail to mutex_trylock(), we release the pool spin_lock and do
> mutex_lock(). After that, we should regrab the pool spin_lock, but,
> regrabbing is missed in current code. So correct it.
> 
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Applied to wq/for-3.10-fixes.

Thanks.

-- 
tejun
