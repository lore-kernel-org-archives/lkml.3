Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3G2SN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:13:27 -0400
Received: from mail-gg0-f171.google.com ([209.85.161.171]:57270 "EHLO
	mail-gg0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab3G2SNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:13:25 -0400
Date: Mon, 29 Jul 2013 14:13:19 -0400
From: Tejun Heo <tj@kernel.org>
To: Zhao Hongjiang <zhaohongjiang@huawei.com>
Cc: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cpuset: get rid of the useless forward declaration
 of cpuset
Message-ID: <20130729181319.GA26076@mtj.dyndns.org>
References: <51F34501.1090608@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F34501.1090608@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 11:56:49AM +0800, Zhao Hongjiang wrote:
> get rid of the useless forward declaration of the struct cpuset cause the 
> below define it.
> 
> Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
