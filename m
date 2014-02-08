Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaBHPgH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 10:36:07 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:38124 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaBHPgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 10:36:06 -0500
Date: Sat, 8 Feb 2014 10:36:01 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET v2 cgroup/for-3.15] cgroup: drop module support and
 cgroup_root_mutex
Message-ID: <20140208153601.GD3263@htj.dyndns.org>
References: <1390952641-15950-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390952641-15950-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 06:43:55PM -0500, Tejun Heo wrote:
>  0001-cgroup-make-CONFIG_CGROUP_NET_PRIO-bool-and-drop-unn.patch
>  0002-cgroup-drop-module-support.patch
>  0003-cgroup-clean-up-cgroup_subsys-names-and-initializati.patch
>  0004-cgroup-rename-cgroup_subsys-subsys_id-to-id.patch
>  0005-cgroup-update-locking-in-cgroup_show_options.patch
>  0006-cgroup-remove-cgroup_root_mutex.patch

0001-0006 applied to cgroup/for-3.15.

Thanks.

-- 
tejun
