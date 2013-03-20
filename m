Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab3CTQkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:40:22 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57259 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3CTQkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:40:21 -0400
Date: Wed, 20 Mar 2013 09:40:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/21] workqueue: cleanups and better locking for recent
 changes
Message-ID: <20130320164015.GA3042@htj.dyndns.org>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
 <CACvQF5117ZW_7jBLt+rK5ZbFdghDqP8SgbwTSMzismvsO-f2WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF5117ZW_7jBLt+rK5ZbFdghDqP8SgbwTSMzismvsO-f2WQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Mar 21, 2013 at 12:38:17AM +0800, Lai Jiangshan wrote:
> I am sorry for replying so late and replied with so huge patchset.
> 
> But problem happened now, my patches and your patches are conflict.
> Which patchset should be rebased?
> 
> I think my patches need be merged at first. Thus workqueue code is
> in a better base, then your patchset will be rebased on this base.
> 
> Since you are maintainer, your choice will be much reasonable.
> If you do any choice, please let me know earlier.
> 
> I should write patches after you are done, even cleanups.

Let me first look at your patches.  I don't really care either way and
don't expect too many conflicts from the two patchsets anyway.  The
NUMA thing is pretty isolated in several functions after all.  Even if
there are conflicts, they shouldn't be too difficult to resolve.
Anyways, will review soon.

Thanks.

-- 
tejun
