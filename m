Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbbA1UWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:22:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42265 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbbA1UWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:22:20 -0500
Date: Wed, 28 Jan 2015 09:54:48 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3.18 11/61] workqueue: fix subtle pool management issue
 which can stall whole worker_pool
Message-ID: <20150128175448.GB28561@kroah.com>
References: <20150128012636.936333725@linuxfoundation.org>
 <20150128012638.187292688@linuxfoundation.org>
 <54C840BA.7020207@cn.fujitsu.com>
 <20150128022456.GF12314@htj.dyndns.org>
 <54C85454.6070303@cn.fujitsu.com>
 <20150128150701.GA3199@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128150701.GA3199@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 10:07:01AM -0500, Tejun Heo wrote:
> On Wed, Jan 28, 2015 at 11:15:32AM +0800, Lai Jiangshan wrote:
> > Was the bug introduced at the first time when maybe_create_worker() was
> > introduced?  Although manage_workers()/maybe_create_worker() was changed a bit,
> > the stable-tree team can simply make manage_workers() return true to fix
> > this bug for the very old kernel versions.
> 
> Yes, this bug has been there from the beginning of cmwq.  I'm
> attaching a patch which is for before the removal of
> maybe_destory_worker().

This patch will apply to 3.10, but not 3.14, and I'm confused.  Should I
backport the original version to 3.14?  3.10?  Use this different
version instead?

confused,

greg k-h
