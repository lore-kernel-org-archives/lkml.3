Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3ANJtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 04:49:07 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57316 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756750Ab3ANJtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 04:49:01 -0500
Message-ID: <50F3D47D.1020103@ti.com>
Date: Mon, 14 Jan 2013 11:48:45 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Alan Stern <stern@rowland.harvard.edu>, <sameo@linux.intel.com>,
        <tony@atomide.com>, <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, <kishon@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/14] usb: ehci-omap: Instantiate PHY devices if required
References: <Pine.LNX.4.44L0.1301111019340.1730-100000@iolanthe.rowland.org> <50F037C9.40306@ti.com> <20130111163255.GF23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130111163255.GF23505@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 06:32 PM, Russell King - ARM Linux wrote:
> On Fri, Jan 11, 2013 at 06:03:21PM +0200, Roger Quadros wrote:
>> diff --git a/include/linux/platform_data/usb-omap.h
>> b/include/linux/platform_data/usb-omap.h
>> index d63eb7d..927b8a1 100644
>> --- a/include/linux/platform_data/usb-omap.h
>> +++ b/include/linux/platform_data/usb-omap.h
>> @@ -38,6 +38,12 @@ enum usbhs_omap_port_mode {
>>  	OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM
>>  };
>>
>> +struct usbhs_phy_config {
>> +	char *name;		/* binds to device driver */
> 
> You may wish to consider making this const.
> 
OK.

--
cheers,
-roger
