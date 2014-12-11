Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbaLKOPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:15:08 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:55998 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916AbaLKOPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:15:06 -0500
Message-ID: <5489A6CD.20909@ti.com>
Date: Thu, 11 Dec 2014 09:14:37 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>
Subject: Re: [PATCH v7 2/3] net: Add Keystone NetCP ethernet driver
References: <1417556503-22290-3-git-send-email-m-karicheri2@ti.com> <20141209.131053.2026868499542642866.davem@davemloft.net> <5488BB96.9070609@ti.com> <20141210.204110.618599360537141819.davem@davemloft.net>
In-Reply-To: <20141210.204110.618599360537141819.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 08:41 PM, David Miller wrote:
> From: Murali Karicheri<m-karicheri2@ti.com>
> Date: Wed, 10 Dec 2014 16:31:02 -0500
>
>> Are you referring to the static code analyser sparse that is invoked
>> through?
>
> You have to explicitly enable endian checking, it's not on by
> default.
Thanks David and others who responded. Let me do this and resolve any 
warning before the next post.

BTW, could you provide any suggestions that would help us merge this 
series to upstream? This has been sitting on this list for a while now.

Thanks and regards,

-- 
Murali Karicheri
Linux Kernel, Texas Instruments
