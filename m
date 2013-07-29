Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab3G2SNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:13:44 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:54674 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3G2SNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:13:43 -0400
Date: Mon, 29 Jul 2013 14:13:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Zhao Hongjiang <zhaohongjiang@huawei.com>
Cc: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpuset: correct the disoder comment of two functions
Message-ID: <20130729181336.GB26076@mtj.dyndns.org>
References: <51F34505.9010505@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F34505.9010505@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 11:56:53AM +0800, Zhao Hongjiang wrote:
> correct the disoder comment between cpuset_css_offline() and
> cpuset_css_free() functions.
> 
> Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
