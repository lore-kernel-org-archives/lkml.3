Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbaAHOpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:45:06 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:2285 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294AbaAHOpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:45:02 -0500
X-IronPort-AV: E=Sophos;i="4.95,624,1384300800"; 
   d="scan'208";a="88734272"
Message-ID: <52CD645B.6060700@citrix.com>
Date: Wed, 8 Jan 2014 14:44:43 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>
CC: <ian.campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v2 0/9] xen-netback: TX grant mapping with SKBTX_DEV_ZEROCOPY
 instead of copy
References: <1389139818-24458-1-git-send-email-zoltan.kiss@citrix.com> <20140108144324.GA6984@zion.uk.xensource.com>
In-Reply-To: <20140108144324.GA6984@zion.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 14:43, Wei Liu wrote:
> You once mentioned that you have a trick to avoid touching TLB, is it in
> this series?
>
> (Haven't really looked at this series as I'm in today. Will have a
> closer look tonight. I'm just curious now.)
>
> Wei.
>
No, I'm currently working on that, it will be a separate series, as it 
also needs some Xen modifications which haven't reached upstream yet AFAIK.

Zoli
