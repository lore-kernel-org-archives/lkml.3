Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaDDOsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:48:06 -0400
Received: from smtp.citrix.com ([66.165.176.89]:56219 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbaDDOsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:48:04 -0400
X-IronPort-AV: E=Sophos;i="4.97,795,1389744000"; 
   d="scan'208";a="118035774"
Message-ID: <533EC612.90400@citrix.com>
Date: Fri, 4 Apr 2014 15:47:46 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <paul.durrant@citrix.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v3 1/2] xen-netback: Rename map ops
References: <1396458298-30041-1-git-send-email-zoltan.kiss@citrix.com> <20140403.142330.1048193401278908355.davem@davemloft.net>
In-Reply-To: <20140403.142330.1048193401278908355.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/14 19:23, David Miller wrote:
> From: Zoltan Kiss <zoltan.kiss@citrix.com>
> Date: Wed, 2 Apr 2014 18:04:57 +0100
>
>> Rename identifiers to state explicitly that they refer to map ops.
>>
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>
> Applied.

Hi,

I still can't see these two on net-next, did something went wrong?

Zoli

p.s.: I've just sent a trivial format string fix on top of this patch
