Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab3DNTRB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 15:17:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58032 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3DNTQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 15:16:59 -0400
Date: Sun, 14 Apr 2013 12:16:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kay@vrfy.org,
        lennart@poettering.net, daniel@zonque.org
Subject: Re: [PATCH 4/4] cgroup: implement task_cgroup_path_from_hierarchy()
Message-ID: <20130414191655.GA10168@kroah.com>
References: <1365964619-14762-1-git-send-email-tj@kernel.org>
 <1365964619-14762-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365964619-14762-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 14, 2013 at 11:36:59AM -0700, Tejun Heo wrote:
> kdbus folks want a sane way to determine the cgroup path that a given
> task belongs to on a given hierarchy, which is a reasonble thing to
> expect from cgroup core.
> 
> Implement task_cgroup_path_from_hierarchy().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Greg Kroah-Hartman <greg@kroah.com>
> Cc: Lennart Poettering <lennart@poettering.net>
> Cc: Daniel Mack <daniel@zonque.org>

Thanks so much for doing this.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
