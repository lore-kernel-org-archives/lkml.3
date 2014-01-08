Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbaAHOII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:08:08 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:12716 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbaAHOIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:08:05 -0500
X-IronPort-AV: E=Sophos;i="4.95,624,1384300800"; 
   d="scan'208";a="88719806"
Message-ID: <52CD5BC2.5020803@citrix.com>
Date: Wed, 8 Jan 2014 14:08:02 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v3 1/9] xen-netback: Introduce TX grant map definitions
References: <1389139818-24458-1-git-send-email-zoltan.kiss@citrix.com>	<1389139818-24458-2-git-send-email-zoltan.kiss@citrix.com> <20140107.202951.729942261773265015.davem@davemloft.net>
In-Reply-To: <20140107.202951.729942261773265015.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 01:29, David Miller wrote:
>> +static inline int tx_dealloc_work_todo(struct xenvif *vif)
>
> Make this return bool.
Done, also in the last patch.

>> +		wait_event_interruptible(vif->dealloc_wq,
>> +					tx_dealloc_work_todo(vif) ||
>> +					 kthread_should_stop());
>
> Inconsistent indentation.  You should make the arguments line up at
> exactly the first column after the openning parenthesis of the function
> call.
Done, thanks.

Zoli

