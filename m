Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935978Ab3DINfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:35:31 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42655 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935719Ab3DINf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:35:29 -0400
Date: Tue, 9 Apr 2013 09:35:14 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Li Zefan <lizefan@huawei.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] cls_cgroup: remove task_struct parameter from
 sock_update_classid()
Message-ID: <20130409133514.GA11337@neilslaptop.think-freely.org>
References: <5163AF37.8010605@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5163AF37.8010605@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 02:03:35PM +0800, Li Zefan wrote:
> The callers always pass current to sock_update_classid().
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

