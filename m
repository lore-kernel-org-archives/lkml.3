Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbaAWVtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:49:17 -0500
Received: from smtp.citrix.com ([66.165.176.89]:4260 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439AbaAWVtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:49:14 -0500
X-IronPort-AV: E=Sophos;i="4.95,708,1384300800"; 
   d="scan'208";a="95952738"
Message-ID: <52E18E57.8040600@citrix.com>
Date: Thu, 23 Jan 2014 21:49:11 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v5 0/9] xen-netback: TX grant mapping with SKBTX_DEV_ZEROCOPY
 instead of copy
References: <1390253069-25507-1-git-send-email-zoltan.kiss@citrix.com>	<20140122.175031.873909526743971037.davem@davemloft.net>	<52E11563.1090707@citrix.com> <20140123.133948.1912867106975845377.davem@davemloft.net>
In-Reply-To: <20140123.133948.1912867106975845377.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/14 21:39, David Miller wrote:
> From: Zoltan Kiss <zoltan.kiss@citrix.com>
> Date: Thu, 23 Jan 2014 13:13:07 +0000
>
>> It is already based on two predecessor patches, one which is already
>> accepted but not applied yet:
>>
>> [PATCH net-next v2] xen-netback: Rework rx_work_todo
>>
>> And the other one is hopefully will be accepted very soon:
>>
>> [PATCH v5] xen/grant-table: Avoid m2p_override during mapping
>
> These have both been asked for changes or small adjustments to be made.
AFAIK Wei acked the netback one:

http://www.spinics.net/lists/netdev/msg267800.html

I've just sent in the latest one for the grant mapping one

> Also, you really have to precisely and explicitly mention any
> dependencies which exist.
Ok, the grant mapping API dependency is vaguely mentioned in the patch 
history, I'll move it. I haven't mentioned the other one because it's 
not related to the grant mapping changes, it's a generic bug.

> In fact, it's often best to not post a series until the dependent
> patches have been accepted.
I've posted the first version of this series in November, these two 
issues turned up in the recent weeks.

Zoli
