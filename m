Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212Ab3CLSeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:34:18 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:38122 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab3CLSeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:34:17 -0400
Date: Tue, 12 Mar 2013 11:34:12 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com
Subject: Re: [PATCHSET wq/for-3.10-tmp] workqueue: implement workqueue with
 custom worker attributes
Message-ID: <20130312183412.GG25266@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 07:23:51PM -0800, Tejun Heo wrote:
> Finally, here's the unbound workqueue with custom worker attributes
> patchset I've been talking about.  The goal is simple.  We want
> unbound workqueues with custom worker attributes with a mechanism to
> expose the knobs to userland.

Applied to wq/for-3.10 with the updated patches.  Some patches needed
minor cosmetic updates because wq/for-3.9-fixes hasn't been merged
yet.  If somebody wants the full patchset posted again, please holler.

Thanks.

-- 
tejun
