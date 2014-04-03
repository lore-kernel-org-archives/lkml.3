Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaDCQfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:35:14 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:52228 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbaDCQfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:35:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140403.123219.186974875530426005.davem@davemloft.net>
References: <20140403160843.GD15134@hansolo.jdub.homelinux.org>
	<20140403.123219.186974875530426005.davem@davemloft.net>
Date: Thu, 3 Apr 2014 12:35:10 -0400
X-Google-Sender-Auth: q5y_6nUsSvPFMTYTQ-Po9uuNo1Y
Message-ID: <CA+5PVA4FG3HEcM3xSbbdy9tFp16uPCdA9zLmz=xAeD+C1EA=9w@mail.gmail.com>
Subject: Re: [PATCH] net: cpts: Add includes for ETH_HLEN and VLAN_HLEN definitions
From: Josh Boyer <jwboyer@fedoraproject.org>
To: David Miller <davem@davemloft.net>
Cc: mugunthanvnm@ti.com, netdev <netdev@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 12:32 PM, David Miller <davem@davemloft.net> wrote:
> From: Josh Boyer <jwboyer@fedoraproject.org>
> Date: Thu, 3 Apr 2014 12:08:43 -0400
>
>> If CONFIG_TI_CPTS is enabled, the ti_cpsw driver will fail to build with:
>>
>> drivers/net/ethernet/ti/cpts.c: In function 'cpts_match':
>> drivers/net/ethernet/ti/cpts.c:266:12: error: 'ETH_HLEN' undeclared (first use in this function)
>>    offset = ETH_HLEN + IPV4_HLEN(data) + UDP_HLEN;
>>             ^
>> drivers/net/ethernet/ti/cpts.c:266:12: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/net/ethernet/ti/cpts.c:276:23: error: 'VLAN_HLEN' undeclared (first use in this function)
>>    offset = ETH_HLEN + VLAN_HLEN;
>>                        ^
>>
>> Add includes of if_ether.h and if_vlan.h to bring in the appropriate defines.
>>
>> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
>
> A patch for this was already submitted to netdev and applied to the 'net'
> GIT tree earlier today.

Ah, great.  Glad it's covered.  Thanks.

josh
