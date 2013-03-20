Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab3CTSWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:22:35 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52505 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab3CTSWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:22:33 -0400
Date: Wed, 20 Mar 2013 11:22:21 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/21] workqueue: avoid false negative in
 assert_manager_or_pool_lock()
Message-ID: <20130320182221.GD30484@htj.dyndns.org>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
 <1363721306-2030-22-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363721306-2030-22-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 03:28:21AM +0800, Lai Jiangshan wrote:
> If lockdep complains something for other subsystem, lockdep_is_held() can be
> false negative. so we need to also test debug_locks before do assert.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.10.

Thanks.

-- 
tejun
