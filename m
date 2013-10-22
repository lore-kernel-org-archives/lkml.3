Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3JVWA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:00:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60012 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3JVWA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:00:26 -0400
Date: Tue, 22 Oct 2013 18:00:23 -0400 (EDT)
Message-Id: <20131022.180023.1141845387743361648.davem@davemloft.net>
To: fengguang.wu@intel.com
Cc: ebiederm@xmission.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: -27% netperf TCP_STREAM regression by "tcp_memcontrol: Kill
 struct tcp_memcontrol"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131022214129.GB2715@localhost>
References: <20131022214129.GB2715@localhost>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 22 Oct 2013 15:00:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: fengguang.wu@intel.com
Date: Tue, 22 Oct 2013 22:41:29 +0100

> We noticed big netperf throughput regressions
> 
>     a4fe34bf902b8f709c63      2e685cad57906e19add7  
> ------------------------  ------------------------  
>                   707.40       -40.7%       419.60  lkp-nex04/micro/netperf/120s-200%-TCP_STREAM
>                  2775.60       -23.7%      2116.40  lkp-sb03/micro/netperf/120s-200%-TCP_STREAM
>                  3483.00       -27.2%      2536.00  TOTAL netperf.Throughput_Mbps
> 
> and bisected it to
> 
> commit 2e685cad57906e19add7189b5ff49dfb6aaa21d3
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Sat Oct 19 16:26:19 2013 -0700
> 
>     tcp_memcontrol: Kill struct tcp_memcontrol

Eric please look into this, I'd rather have a fix to apply than revert your
work.

Thanks.
