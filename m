Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaCXMvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:51:45 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:55264 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbaCXMvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:51:42 -0400
Date: Mon, 24 Mar 2014 08:51:39 -0400
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [patch 1/2] workqueue: Provide destroy_delayed_work_on_stack()
Message-ID: <20140324125139.GC29892@mtj.dyndns.org>
References: <20140323141648.703530841@linutronix.de>
 <20140323141939.911487677@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140323141939.911487677@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 02:20:44PM -0000, Thomas Gleixner wrote:
> If a delayed or deferrable work is on stack we need to tell debug
> objects that we are destroying the timer and the work. Otherwise we
> leak the tracking object.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tejun Heo <tj@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

How do you want to route this?  If it's better to route it with the
next patch, please feel free to do so.

Thanks.

-- 
tejun
