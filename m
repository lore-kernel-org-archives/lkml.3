Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab3ILDdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 23:33:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3ILDdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 23:33:35 -0400
Date: Wed, 11 Sep 2013 20:33:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, kay@vrfy.org, ebiederm@xmission.com,
        netdev@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCHSET] sysfs: disentangle kobject namespace handling from
 sysfs
Message-ID: <20130912033344.GA10584@kroah.com>
References: <1378952949-7900-1-git-send-email-tj@kernel.org>
 <20130912031912.GA9773@kroah.com>
 <20130912032316.GB8251@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912032316.GB8251@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 11:23:16PM -0400, Tejun Heo wrote:
> Hello, Greg.
> 
> > Nice job with these.  Do you want me to add them to my tree for 3.13, or
> > do you want to take them through yours as you will be building on top of
> > them?
> 
> I think it'll be best to route them through your tree but maybe we
> want to wait a bit before applying them?

I have to wait for 3.12-rc1 to come out before applying anything, and
then we will be at LinuxCon/Plumbers drinking^Wworking all next week, so
it will be a bit before any of this could hit my tree.

thanks,

greg k-h
