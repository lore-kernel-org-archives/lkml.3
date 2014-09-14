Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaINIas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 04:30:48 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:33417 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbaINIai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 04:30:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140912.181605.1878319812562851527.davem@davemloft.net>
References: <78ce1faf-0bf8-41bb-a30d-cecd11d82d94@BY2FFO11FD033.protection.gbl>
	<20140912.181605.1878319812562851527.davem@davemloft.net>
Date: Sun, 14 Sep 2014 14:00:36 +0530
Message-ID: <CALHRZuqGNAo7DLwGx1CYhcEF0rVurgGU3TyWq1fN4Oqp3k9Mtg@mail.gmail.com>
Subject: Re: [PATCH] net: axienet: remove unnecessary ether_setup after alloc_etherdev
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>, svemula@xilinx.com,
        anirudh@xilinx.com, Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks David,

Sundeep.

On Sat, Sep 13, 2014 at 3:46 AM, David Miller <davem@davemloft.net> wrote:
> From: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>
> Date: Thu, 11 Sep 2014 14:53:33 +0530
>
>> calling ether_setup is redundant since alloc_etherdev calls
>> it.
>>
>> Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
>
> Applied.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
