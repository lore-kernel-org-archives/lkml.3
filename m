Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab3AXSne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:43:34 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64446 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3AXSnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:43:32 -0500
Date: Thu, 24 Jan 2013 10:43:26 -0800
From: Tejun Heo <tj@kernel.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: un-GPL function delayed_work_timer_fn()
Message-ID: <20130124184326.GN2373@mtj.dyndns.org>
References: <20130124123630.11433.32503.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124123630.11433.32503.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 04:36:31PM +0400, Konstantin Khlebnikov wrote:
> commit d8e794dfd51c368ed3f686b7f4172830b60ae47b ("workqueue: set
> delayed_work->timer function on initialization") exports function
> delayed_work_timer_fn() only for GPL modules. This makes delayed-works
> unusable for non-GPL modules, because initialization macro now requires
> GPL symbol. For example schedule_delayed_work() available for non-GPL.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: stable@vger.kernel.org # 3.7

Applied to wq/for-3.8-fixes.  Thanks.

-- 
tejun
