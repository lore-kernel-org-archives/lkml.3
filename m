Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046AbaDOQSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:18:34 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:59977 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaDOQSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:18:33 -0400
Date: Tue, 15 Apr 2014 12:18:28 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, john@johnmccutchan.com, rlove@rlove.org,
        eparis@parisplace.org, serge.hallyn@ubuntu.com, lennart@poettering.net,
        kay@vrfy.org, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement cgroup.populated
Message-ID: <20140415161828.GA30990@htj.dyndns.org>
References: <1397056052-2829-1-git-send-email-tj@kernel.org>
 <20140414213100.GA1863@htj.dyndns.org>
 <20140414222658.GA18152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414222658.GA18152@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

On Mon, Apr 14, 2014 at 03:26:58PM -0700, Greg KH wrote:
> Do you want me to pull this branch into my tree for 3.16 now?  I have no
> objection to you taking it, if that's easier for you, which ever is fine
> for me.

I think the best way to proceed would be applying 1-2 to
driver-core-next and then base cgroup/for-3.16 on top of it, but I'd
like to get some feedback from inotify people before proceeding.

Thanks.

-- 
tejun
