Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbaDNWYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:24:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbaDNWX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:23:59 -0400
Date: Mon, 14 Apr 2014 15:26:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, john@johnmccutchan.com, rlove@rlove.org,
        eparis@parisplace.org, serge.hallyn@ubuntu.com, lennart@poettering.net,
        kay@vrfy.org, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement cgroup.populated
Message-ID: <20140414222658.GA18152@kroah.com>
References: <1397056052-2829-1-git-send-email-tj@kernel.org>
 <20140414213100.GA1863@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414213100.GA1863@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 05:31:00PM -0400, Tejun Heo wrote:
> On Wed, Apr 09, 2014 at 11:07:29AM -0400, Tejun Heo wrote:
> > This patchset is on top of "cgroup: implement unified hierarchy"
> > patchset[1] and availalbe in the following git branch.
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-populated
> 
> Branch renamed to review-populated-v1.

Do you want me to pull this branch into my tree for 3.16 now?  I have no
objection to you taking it, if that's easier for you, which ever is fine
for me.

thanks,

greg k-h
