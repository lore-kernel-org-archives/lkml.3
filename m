Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbaDRUlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 16:41:17 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:45384 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaDRUlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 16:41:12 -0400
Date: Fri, 18 Apr 2014 16:41:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/12] cgroup: implement dynamic subtree controller
 enable/disable on the default hierarchy
Message-ID: <20140418204108.GL23576@htj.dyndns.org>
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
 <1397511430-2673-13-git-send-email-tj@kernel.org>
 <CAC4Lta0tD=FbtVpGnLw2sKMY69+AnqYqaOvCQdFs88JeR5Pemw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC4Lta0tD=FbtVpGnLw2sKMY69+AnqYqaOvCQdFs88JeR5Pemw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 17, 2014 at 11:33:50PM +0530, Raghavendra KT wrote:
> On Tue, Apr 15, 2014 at 3:07 AM, Tejun Heo <tj@kernel.org> wrote:
> I undertsand that with the above parsing we could do
> echo "-blkio +blkio" > cgroup.subtree_control and honor last enable/disable.

Yeah, and the behavior is described in the following document.

 http://lkml.kernel.org/g/20140416145248.GD1257@htj.dyndns.org

> It confused me while testing. do you think we should return -EINVAL in
> such case?

Hmmm... I think whatever comes later wins is a pretty clear and easy
rule, no?

-- 
tejun
