Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3KSRZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:25:20 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:51056 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720Ab3KSRZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:25:16 -0500
Message-ID: <528B9EF6.3090708@mellanox.com>
Date: Tue, 19 Nov 2013 19:25:10 +0200
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] please pull infiniband.git
References: <1384800032-14755-1-git-send-email-roland@kernel.org>
In-Reply-To: <1384800032-14755-1-git-send-email-roland@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.222.66.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/11/2013 20:40, Roland Dreier wrote:
> Hi Linus,
>
> Please pull from
>
>      git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus
>
> ----------------------------------------------------------------
>
> Main batch of InfiniBand/RDMA changes for 3.13:
>
>   - Re-enable flow steering verbs with new improved userspace ABI
>   - Fixes for slow connection due to GID lookup scalability
>   - IPoIB fixes
>   - Many fixes to HW drivers including mlx4, mlx5, ocrdma and qib
>   - Further improvements to SRP error handling
>   - Add new transport type for Cisco usNIC

Hi Roland, can you spare few words on how you see the RoCE IP based Addressing V5 series? we have addressed the concerns you raised re compatibility and also simplified the series to avoid using uverbs extensions @ this point, anything else left there?

This series is pre-step for submitting SRIOV support to RoCE (the code is ready!) and hence no Cloud RoCE upstream solution for VMs before we nail that, it deserves your response. I have posted reply on Sep 17th, to your concerns http://marc.info/?l=linux-rdma&m=137945099714426&w=2 and didn't really hear from you. So went ahead and addressed the feedback as we captured it.

Or.


