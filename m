Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3CMAnC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 20:43:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49353 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab3CMAnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 20:43:00 -0400
Date: Tue, 12 Mar 2013 17:42:56 -0700
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, laijs@cn.fujitsu.com, fengguang.wu@intel.com
Cc: linux-kernel@vger.kernel.org, jmoyer@redhat.com
Subject: Re: [PATCH 1/4] implement current_is_workqueue_rescuer()
Message-ID: <20130313004256.GB2999@htj.dyndns.org>
References: <1362692649-25570-1-git-send-email-tj@kernel.org>
 <1362692649-25570-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362692649-25570-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 01:44:06PM -0800, Tejun Heo wrote:
> Implement a function which queries whether it currently is running off
> a workqueue rescuer.  This will be used to convert writeback to
> workqueue.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Applied this one to wq/for-3.10.

Thanks.

-- 
tejun
