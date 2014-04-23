Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbaDWPQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:16:49 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:40947 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaDWPQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:16:42 -0400
Date: Wed, 23 Apr 2014 11:16:38 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, john@johnmccutchan.com, rlove@rlove.org,
        eparis@parisplace.org, serge.hallyn@ubuntu.com, lennart@poettering.net,
        kay@vrfy.org, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement cgroup.populated
Message-ID: <20140423151638.GG4781@htj.dyndns.org>
References: <1397056052-2829-1-git-send-email-tj@kernel.org>
 <20140414213100.GA1863@htj.dyndns.org>
 <20140414222658.GA18152@kroah.com>
 <20140415161828.GA30990@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415161828.GA30990@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:18:28PM -0400, Tejun Heo wrote:
> Hello, Greg.
> 
> On Mon, Apr 14, 2014 at 03:26:58PM -0700, Greg KH wrote:
> > Do you want me to pull this branch into my tree for 3.16 now?  I have no
> > objection to you taking it, if that's easier for you, which ever is fine
> > for me.
> 
> I think the best way to proceed would be applying 1-2 to
> driver-core-next and then base cgroup/for-3.16 on top of it, but I'd
> like to get some feedback from inotify people before proceeding.

Greg, can you please apply the first two patches to driver-core-next
(or a separate branch which is pulled into driver-core-next, either
way works for me as long as the branch is stable)?  I'll pull in the
branch and route the third patch through cgroup/for-3.16.

Thanks!

-- 
tejun
