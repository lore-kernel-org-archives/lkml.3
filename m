Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbaHGMgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 08:36:09 -0400
Received: from smtp.citrix.com ([66.165.176.89]:9437 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbaHGMgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 08:36:05 -0400
X-IronPort-AV: E=Sophos;i="5.01,818,1400025600"; 
   d="scan'208";a="159638853"
Message-ID: <53E372B2.6030509@citrix.com>
Date: Thu, 7 Aug 2014 13:36:02 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <wei.liu2@citrix.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH] xen-netback: Change disable flag from bool to a bit
References: <1407348973-2433-1-git-send-email-zoltan.kiss@citrix.com>	<1407348973-2433-5-git-send-email-zoltan.kiss@citrix.com> <20140806.140722.489043833669403528.davem@davemloft.net>
In-Reply-To: <20140806.140722.489043833669403528.davem@davemloft.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/14 22:07, David Miller wrote:
> From: Zoltan Kiss <zoltan.kiss@citrix.com>
> Date: Wed, 6 Aug 2014 19:16:13 +0100
>
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
>
> Neither this nor your "Small fixes around internal queue purging"
> patch apply cleanly to my current tree.  I have no idea what tree you
> are sending these patches against.
>
This was an accidental submit, as I wrote in my email a minute later. 
Sorry about it.

Zoli
