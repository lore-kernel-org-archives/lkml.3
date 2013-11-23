Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3KWXJl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 18:09:41 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:50696 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab3KWXJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 18:09:40 -0500
Date: Sat, 23 Nov 2013 18:09:37 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: Re: [PATCHSET driver-core-next] sysfs: separate out kernfs, take #3
Message-ID: <20131123230937.GD29774@mtj.dyndns.org>
References: <1385245346-856-1-git-send-email-tj@kernel.org>
 <20131123224835.GA29774@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123224835.GA29774@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Nov 23, 2013 at 05:48:35PM -0500, Tejun Heo wrote:
> Please hold on a bit.  I have !CONFIG_SYSFS build failure.  I think I
> forgot to add dummy interface for a newly added function.  I'm fixing
> it right now.

Alright, the end result is the same.  0001 was missing dummy
implementation of sysfs_enable_ns() but 0009, while replacing it with
kernfs_enable_ns(), added the equivalent.  The patches are fixed so
that 0001 adds dummy sysfs_enable_ns() and 0009 replaces that with
kernfs_enable_ns(), but the end result is the same.

All the git branches are updated accordingly.

Thanks.

-- 
tejun
