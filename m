Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaATQxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:53:39 -0500
Received: from smtp.citrix.com ([66.165.176.89]:59848 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbaATQxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:53:38 -0500
X-IronPort-AV: E=Sophos;i="4.95,691,1384300800"; 
   d="scan'208";a="94558144"
Message-ID: <52DD548F.2060409@citrix.com>
Date: Mon, 20 Jan 2014 16:53:35 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>
CC: <ian.campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v4 1/9] xen-netback: Introduce TX grant map definitions
References: <1389731995-9887-1-git-send-email-zoltan.kiss@citrix.com> <1389731995-9887-2-git-send-email-zoltan.kiss@citrix.com> <20140116000040.GA5331@zion.uk.xensource.com>
In-Reply-To: <20140116000040.GA5331@zion.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/01/14 00:00, Wei Liu wrote:
> There is a stray blank line change in xenvif_tx_create_gop. (I removed
> that part too early and didn't bother to paste it back...)
Ok, fixed

>> +static inline bool tx_dealloc_work_todo(struct xenvif *vif)
>> +{
>> +	if (vif->dealloc_cons != vif->dealloc_prod)
>> +		return true;
>> +
>> +	return false;
>
> This can be simplified as
>    return vif->dealloc_cons != vif->dealloc_prod;
Indeed, done.


