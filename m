Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaDCKBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 06:01:47 -0400
Received: from 1wt.eu ([62.212.114.60]:2888 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbaDCKBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 06:01:44 -0400
Date: Thu, 3 Apr 2014 12:01:28 +0200
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
Message-ID: <20140403100128.GE16158@1wt.eu>
References: <53310F4E.4080104@gmail.com> <533D25D4.4000607@gmail.com> <20140403092727.GD16158@1wt.eu> <533D30A1.1060509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533D30A1.1060509@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhu,

On Thu, Apr 03, 2014 at 05:57:53PM +0800, zhuyj wrote:
> I reference the following 2 mainline commits. These 2 commits are based 
> on the current kernel 3.x and ethtool.
> If we only backport these 2 commits on kernel 2.6.x, this problem will 
> not be fixed yet.

OK fine, I just wanted that we keep the reference of these equivalent
patches in the commit message so that if later a newer patch changes
anything they did, at least we have some indications that the commit
might also have to be revisited.

I'll merge your patch and put these references there.

Thanks,
Willy

