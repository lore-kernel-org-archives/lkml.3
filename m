Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab3ILDeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 23:34:31 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:61094 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab3ILDe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 23:34:29 -0400
Date: Wed, 11 Sep 2013 23:34:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, kay@vrfy.org, ebiederm@xmission.com,
        netdev@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCHSET] sysfs: disentangle kobject namespace handling from
 sysfs
Message-ID: <20130912033426.GC8251@htj.dyndns.org>
References: <1378952949-7900-1-git-send-email-tj@kernel.org>
 <20130912031912.GA9773@kroah.com>
 <20130912032316.GB8251@htj.dyndns.org>
 <20130912033344.GA10584@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912033344.GA10584@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 08:33:44PM -0700, Greg KH wrote:
> I have to wait for 3.12-rc1 to come out before applying anything, and
> then we will be at LinuxCon/Plumbers drinking^Wworking all next week, so
> it will be a bit before any of this could hit my tree.

Heh, sounds good.  See you soon in New Orleans! :)

-- 
tejun
