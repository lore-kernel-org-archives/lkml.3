Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaGHGNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:13:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41995 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaGHGM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:12:59 -0400
Message-ID: <53BB8BDA.3020205@ti.com>
Date: Tue, 8 Jul 2014 11:42:42 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] phy: phy-samsung-usb2: Change phy power on/power
 off sequence
References: <1404715705-5041-1-git-send-email-kishon@ti.com> <1404715705-5041-4-git-send-email-kishon@ti.com> <20140708014442.GB13844@kroah.com>
In-Reply-To: <20140708014442.GB13844@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tuesday 08 July 2014 07:14 AM, Greg KH wrote:
> On Mon, Jul 07, 2014 at 12:18:20PM +0530, Kishon Vijay Abraham I wrote:
>> From: Kamil Debski <k.debski@samsung.com>
>>
>> The Exynos4412 USB 2.0 PHY hardware differs from the description provided
>> in the documentation. Some register bits have different function. This
>> patch fixes the defines of register bits and changes the way how phys are
>> powered on and off.
>>
>> Signed-off-by: Kamil Debski <k.debski@samsung.com>
>> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> Tested-by: Daniel Drake <drake@endlessm.com>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  drivers/phy/phy-exynos4x12-usb2.c |  112 +++++++++++++++++++++++++------------
>>  drivers/phy/phy-exynos5250-usb2.c |    2 -
>>  drivers/phy/phy-samsung-usb2.h    |    3 +-
>>  3 files changed, 77 insertions(+), 40 deletions(-)
>>
> 
> This doesn't look like a regression fix for 3.16-final, it looks like a
> "new feature" to me :(

This patch was primarily due to the incorrectly documented register bits in the
manual. So thought this would qualify as fix and should be in 3.16.

Thanks
Kishon
