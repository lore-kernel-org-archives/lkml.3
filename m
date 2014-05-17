Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbaEQFme (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 01:42:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57460 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677AbaEQFmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 01:42:32 -0400
Message-ID: <5376F6C1.7000907@gmail.com>
Date: Sat, 17 May 2014 13:42:25 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        gxt@mprc.pku.edu.cn, matanb@mellanox.com, ogerlitz@mellanox.com,
        eyalpe@mellanox.com, amirv@mellanox.com, sbohrer@rgmadvisors.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] drivers: net: ethernet: mellanox: mlx4: let mlx4 depend
 on SMP
References: <5376F2F8.3010603@gmail.com> <20140517.013655.349586284786993619.davem@davemloft.net>
In-Reply-To: <20140517.013655.349586284786993619.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2014 01:36 PM, David Miller wrote:
> From: Chen Gang <gang.chen.5i5j@gmail.com>
> Date: Sat, 17 May 2014 13:26:16 +0800
> 
>> 'struct irq_affinity_notify' and the related functions are only defined
>> when SMP enabled, so at present, mlx4 has to only run under SMP.
>>
>> The related error (allmodconfig under unicore32):
> 
> Making the entire driver depend upon SMP is not the answer,
> other Mellanox developers said that a proper fix is pending
> so please be patient.
> 

OK, thank you for your information. I shall bypass it, and continue.

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
