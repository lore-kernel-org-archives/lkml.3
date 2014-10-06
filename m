Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaJFM71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:59:27 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:63733 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaJFM7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:59:25 -0400
Message-ID: <54329389.2050304@gmail.com>
Date: Mon, 06 Oct 2014 21:05:13 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richard@nod.at
Subject: Re: [PATCH] drivers/net/phy/Kconfig: Let MDIO_BCM_UNIMAC depend on
 HAS_IOMEM
References: <542FC3D9.4080607@gmail.com> <20141006.004646.685997864382345892.davem@davemloft.net>
In-Reply-To: <20141006.004646.685997864382345892.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/6/14 12:46, David Miller wrote:
> From: Chen Gang <gang.chen.5i5j@gmail.com>
> Date: Sat, 04 Oct 2014 17:54:33 +0800
> 
>> MDIO_BCM_UNIMAC needs HAS_IOMEM, so depend on it, the related error (
>> with allmodconfig under um):
>>
>>     MODPOST 1205 modules
>>   ERROR: "devm_ioremap" [drivers/net/phy/mdio-bcm-unimac.ko] undefined!
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> 
> Applied, thanks.
> 

Thank you for your work.

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
