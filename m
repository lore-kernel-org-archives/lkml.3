Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab3DOD5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 23:57:34 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:49813 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab3DOD5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 23:57:33 -0400
Date: Sun, 14 Apr 2013 20:57:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, kay@vrfy.org, greg@kroah.com,
        lennart@poettering.net, daniel@zonque.org
Subject: Re: [PATCH 4/4] cgroup: implement task_cgroup_path_from_hierarchy()
Message-ID: <20130415035720.GN3050@htj.dyndns.org>
References: <1365964619-14762-1-git-send-email-tj@kernel.org>
 <1365964619-14762-5-git-send-email-tj@kernel.org>
 <516B7753.9060503@huawei.com>
 <20130415034613.GK3050@htj.dyndns.org>
 <516B78E5.6000109@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516B78E5.6000109@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Li.

On Mon, Apr 15, 2013 at 11:49:57AM +0800, Li Zefan wrote:
> But if id is invalid, idr_find() will return NULL. As long as root is not NULL,
> task_cgroup_from_root() will always return a valid cgroup.

I'm hopping across multiple devel branches quickly today and somewhat
tipsy.  Sorry about the blabber.  :)

-- 
tejun
