Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab3DASXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:23:08 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55064 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab3DASXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:23:06 -0400
Date: Mon, 1 Apr 2013 11:22:57 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] workqueue: fix race condition in unbound workqueue
 free path
Message-ID: <20130401182257.GA3142@htj.dyndns.org>
References: <20130328062947.GA14088@htj.dyndns.org>
 <20130328063129.GC14088@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130328063129.GC14088@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 11:31:29PM -0700, Tejun Heo wrote:
> Oops, forgot something.
> 
> Both patches are against wq/for-3.10 and fix problems introduced in
> this devel cycle, so no need to be alarmed.

Applied to wq/for-3.10.

-- 
tejun
