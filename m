Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab3ENSpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:45:51 -0400
Received: from mail-ye0-f169.google.com ([209.85.213.169]:56148 "EHLO
	mail-ye0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab3ENSpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:45:49 -0400
Date: Tue, 14 May 2013 11:45:43 -0700
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, kay@vrfy.org, greg@kroah.com,
        lennart@poettering.net, daniel@zonque.org
Subject: Re: [PATCHSET] cgroup: implement task_cgroup_path_from_hierarchy()
Message-ID: <20130514184543.GP6795@mtj.dyndns.org>
References: <1365964619-14762-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365964619-14762-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 14, 2013 at 11:36:55AM -0700, Tejun Heo wrote:
> kdbus folks want a sane way to determine the cgroup path that a given
> task belongs to on a given hierarchy, which is a reasonble thing to
> expect from cgroup core.

Applied to cgroup/for-3.11.

Thanks.

-- 
tejun
