Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbaDVUd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:33:56 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:49681 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938AbaDVUdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:33:53 -0400
Date: Tue, 22 Apr 2014 16:33:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: davem@davemloft.net, lizefan@huawei.com, nhorman@tuxdriver.com,
        daniel.wagner@bmw-carit.de, jiri@resnulli.us, gaofeng@cn.fujitsu.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] netprio_cgroup: use accessor to get id from css
Message-ID: <20140422203348.GE2314@mtj.dyndns.org>
References: <cover.1398147734.git.nasa4836@gmail.com>
 <0b10af801af45fdbf4835e8da54273e9752b239f.1398147734.git.nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b10af801af45fdbf4835e8da54273e9752b239f.1398147734.git.nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 02:31:01PM +0800, Jianyu Zhan wrote:
> This is a prepared patch for converting from per-cgroup id to
> per-subsystem id.
> 
> We should not access per-cgroup id directly, since this is
> implemetation detail.
> 
> Use the accessor css_from_id() instead.
> 
> This patch has no functional change.

netprio_cgroup is a cgroup identifying controller.  We *do* want to
use per-cgroup IDs for it.

Thanks.

-- 
tejun
