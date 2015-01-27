Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbbA0SST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:18:19 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:57796 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093AbbA0SSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:18:16 -0500
Date: Tue, 27 Jan 2015 13:18:05 -0500
From: Tejun Heo <tj@kernel.org>
To: Jason Low <jason.low2@hp.com>
Cc: Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org, aswin@hp.com
Subject: Re: [PATCH] cgroup: Initialize root in cgroup_mount
Message-ID: <20150127181805.GD12314@htj.dyndns.org>
References: <1422318099.6710.3.camel@j-VirtualBox>
 <20150127161009.GB12314@htj.dyndns.org>
 <1422380796.6710.13.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1422380796.6710.13.camel@j-VirtualBox>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 09:46:36AM -0800, Jason Low wrote:
> On Tue, 2015-01-27 at 11:10 -0500, Tejun Heo wrote:
> > On Mon, Jan 26, 2015 at 04:21:39PM -0800, Jason Low wrote:
> > > Compiling kernel/ causes warnings:
> > > 
> > >     ... ‘root’ may be used uninitialized in this function
> > >     ... ‘root’ was declared here
> > > 
> > > This isn't an issue since there is already logic to not use
> > > root if we goto out_unlock without setting root.
> > > 
> > > Explicitly initialize root to NULL to suppress this so that we can
> > > focus on catching warnings that can potentially cause bigger issues.
> > 
> > Which complier are you using?
> 
> Hi Tejun, one of the versions I am seeing this on is gcc 4.6.3.

Can you plesae try something newer?  gcc for a while had trouble with
these spurious warnings.  4.6.2 is 3+ years old now.

Thanks.

-- 
tejun
