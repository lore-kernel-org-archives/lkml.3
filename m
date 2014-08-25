Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbaHYOkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:40:16 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:41563 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaHYOkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:40:14 -0400
Date: Mon, 25 Aug 2014 10:40:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: Enable controllers for default hierarchy by
 default.
Message-ID: <20140825144009.GB31066@mtj.dyndns.org>
References: <1408966052-2076-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408966052-2076-1-git-send-email-yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dongsheng.

On Mon, Aug 25, 2014 at 07:27:32PM +0800, Dongsheng Yang wrote:
> When we create a cgroup in unified hierarchy, we have to enable
> controllers in cgrp_dfl_root.subtree_control manually. From
> my practice, I did not find the benefit we disable controllers
> in cgrp_dfl_root by default.

Hehe, I actually enjoyed the frankness.  No fudging around, basically
just "I used it for a bit and it didn't feel useful to me".

> As I am a newbie to cgroup, please correct me if I am wrong.

I don't think being new to cgroup is important here.  Regardless of
the specific area, you should be able to build and argue the
rationales for the changes you propose.  This is important because not
only the changes need to be justified but also the process will help
you actually think about and analyze the changes that you're
proposing.  If you can't build strong enough rationales for a given
change, it probably shouldn't be proposed.

Here, your rationale is nothing more than "I played with it 5 mins and
it seemed weird to me".  There was no effort in understanding the
overall design, use cases or implications.  You're just driving by
shooting random patches expecting other people to do what you should
have done before submitting the patches.  If you want to change the
behavior, please first study and think about it and ask specific
questions when unsure.  Submitting basically random patches expecting
others to argue for or against it is one of the worst ways to learn
about a subsystem.  Please don't ever do this regardless of the
subsystem in question.

Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
