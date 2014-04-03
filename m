Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaDCJmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:42:15 -0400
Received: from 1wt.eu ([62.212.114.60]:2881 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaDCJmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:42:10 -0400
X-Greylist: delayed 863 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2014 05:42:10 EDT
Date: Thu, 3 Apr 2014 11:27:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: zhuyj <zyjzyj2000@gmail.com>
Cc: sandeep.kumar@freescale.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Tao, Yue" <Yue.Tao@windriver.com>,
        "Yang, Zhangle (Eric)" <Zhangle.Yang@windriver.com>,
        guang.yang@windriver.com, joe@perches.com, festevam@gmail.com,
        linuxppc-dev@lists.ozlabs.org, richardcochran@gmail.com,
        clarocq@gmail.com, yongjun_wei@trendmicro.com.cn,
        Claudiu Manoil <claudiu.manoil@freescale.com>
Subject: Re: on kernel 2.6.34.15, vlan and raw packets can not be received with gfar-enet nic
Message-ID: <20140403092727.GD16158@1wt.eu>
References: <53310F4E.4080104@gmail.com> <533D25D4.4000607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533D25D4.4000607@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhu,

On Thu, Apr 03, 2014 at 05:11:48PM +0800, zhuyj wrote:
> Hi, Claudiu
> 
> Please help to review this patch. This patch is for kernel 2.6.x. Thanks 
> a lot.
> 
> Hi, Willy
> 
> Please help to merge this patch to longterm: 2.6.32.61 since this 
> problem also occurs on this kernel. Thanks a lot.

Could you please send the reference to the equivalent mainline commit (the one
which disables the tx vlan feature I'm assuming) ? I'll happily queue it for
2.6.32.62.

Thanks,
Willy

