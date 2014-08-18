Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaHROUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:20:40 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:33642 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaHROUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:20:39 -0400
Date: Mon, 18 Aug 2014 10:20:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Alban Crequy <alban.crequy@collabora.co.uk>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v2] cgroup: reject cgroup names with '\n'
Message-ID: <20140818142034.GA17668@mtj.dyndns.org>
References: <1408360820-3390-1-git-send-email-alban.crequy@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408360820-3390-1-git-send-email-alban.crequy@collabora.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 12:20:20PM +0100, Alban Crequy wrote:
> /proc/<pid>/cgroup contains one cgroup path on each line. If cgroup names are
> allowed to contain "\n", applications cannot parse /proc/<pid>/cgroup safely.
> 
> Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>

Applied to cgroup/for-3.17-fixes w/ stable cc'd.

Thanks!

-- 
tejun
