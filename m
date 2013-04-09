Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935899Ab3DITqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:46:48 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:37442 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761961Ab3DITqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:46:46 -0400
Date: Tue, 9 Apr 2013 12:46:40 -0700
From: Tejun Heo <tj@kernel.org>
To: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, bsingharora@gmail.com, dhaval.giani@gmail.com,
        Kay Sievers <kay.sievers@vrfy.org>, jpoimboe@redhat.com,
        lpoetter@redhat.com, workman-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130409194640.GK6186@mtj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <20130409095024.GI25576@redhat.com>
 <20130409193851.GJ6186@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409193851.GJ6186@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bit of addition.

On Tue, Apr 09, 2013 at 12:38:51PM -0700, Tejun Heo wrote:
> > We need to make the distribute approach work in order to support
> > containers, which requiring them to have a back-channel open to
> > the host userspace. If we can do that, then we've solved the problem

Why is back-channel such a bad thing?  Even fully virtualized
environments do special things to communicate with the host (the whole
stack of virt drivers).  It is sub-optimal and pointless to make
everything completely transparent.  There's nothing wrong with the
basesystem knowing that they're inside a container or a virtualized
environment, so I don't understand why a back-channel is such a big
problem.

Thanks.

-- 
tejun
