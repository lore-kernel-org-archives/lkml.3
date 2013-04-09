Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935719Ab3DINjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:39:54 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42765 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab3DINjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:39:53 -0400
Date: Tue, 9 Apr 2013 09:39:43 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Li Zefan <lizefan@huawei.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] netprio_cgroup: remove task_struct parameter from
 sock_update_netprio()
Message-ID: <20130409133943.GB11337@neilslaptop.think-freely.org>
References: <5163AF37.8010605@huawei.com>
 <5163AF43.502@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5163AF43.502@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 02:03:47PM +0800, Li Zefan wrote:
> The callers always pass current to sock_update_netprio().
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

