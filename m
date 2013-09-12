Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab3ILDXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 23:23:24 -0400
Received: from mail-ye0-f181.google.com ([209.85.213.181]:48843 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab3ILDXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 23:23:21 -0400
Date: Wed, 11 Sep 2013 23:23:16 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, kay@vrfy.org, ebiederm@xmission.com,
        netdev@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCHSET] sysfs: disentangle kobject namespace handling from
 sysfs
Message-ID: <20130912032316.GB8251@htj.dyndns.org>
References: <1378952949-7900-1-git-send-email-tj@kernel.org>
 <20130912031912.GA9773@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912031912.GA9773@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

> Nice job with these.  Do you want me to add them to my tree for 3.13, or
> do you want to take them through yours as you will be building on top of
> them?

I think it'll be best to route them through your tree but maybe we
want to wait a bit before applying them?

Thanks!

-- 
tejun
