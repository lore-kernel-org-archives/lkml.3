Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaGHGSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:18:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36660 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHGSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:18:52 -0400
Message-ID: <53BB8D3B.8060109@ti.com>
Date: Tue, 8 Jul 2014 11:48:35 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] phy: core: Support regulator supply for PHY power
References: <1404715705-5041-1-git-send-email-kishon@ti.com> <1404715705-5041-7-git-send-email-kishon@ti.com> <20140708014527.GD13844@kroah.com>
In-Reply-To: <20140708014527.GD13844@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tuesday 08 July 2014 07:15 AM, Greg KH wrote:
> On Mon, Jul 07, 2014 at 12:18:23PM +0530, Kishon Vijay Abraham I wrote:
>> From: Roger Quadros <rogerq@ti.com>
>>
>> Some PHYs can be powered by an external power regulator.
>> e.g. USB_HS PHY on DRA7 SoC. Make the PHY core support a
>> power regulator.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  drivers/phy/phy-core.c  |   26 ++++++++++++++++++++++++++
>>  include/linux/phy/phy.h |    2 ++
>>  2 files changed, 28 insertions(+)
> 
> This looks like a new feature :(
> 
> again, I can't take that for 3.16-final, you know better...

In the outset it looks like a new feature (which actually is) but it actually
is needed to get USB and SATA working in DRA7xx. It was working before since
these regulators were *always on* before. But now the the users of these
regulators should explicitly enable it.

Thanks
Kishon
