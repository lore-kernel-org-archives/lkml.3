Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab3AOOYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 09:24:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49205 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab3AOOYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 09:24:52 -0500
Message-ID: <50F56697.9060803@ti.com>
Date: Tue, 15 Jan 2013 19:54:23 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <grant.likely@secretlab.ca>, <b-cousson@ti.com>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <balbi@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [RFC PATCH 1/7] drivers: usb: phy: add a new driver for usb part
 of control module
References: <1358239378-10030-1-git-send-email-kishon@ti.com> <1358239378-10030-2-git-send-email-kishon@ti.com> <201301151336.47546.arnd@arndb.de>
In-Reply-To: <201301151336.47546.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tuesday 15 January 2013 07:06 PM, Arnd Bergmann wrote:
> On Tuesday 15 January 2013, Kishon Vijay Abraham I wrote:
>> +OMAP CONTROL USB
>> +
>> +Required properties:
>> + - compatible: Should be "ti,omap-control-usb"
>> + - reg : Address and length of the register set for the device. It contains
>> +   the address of "control_dev_conf" and "otghs_control".
>> + - reg-names: The names of the register addresses corresponding to the registers
>> +   filled in "reg".
>> + - ti,has_mailbox: This is used to specify if the platform uses mailbox in
>> +   control module.
>
> I wonder whether we need to have a phandle here to connect the control device
> to the actual usb device. What happens if you have multiple instances of
> each?

Good point :-). Currently, none of the OMAP platforms have multiple 
control modules and it doesn't seem to be in the future (AFAIK). While 
it might be simpler to support multiple control devices with phandle, it 
might face the same complications as faced by the USB PHY framework for 
non-dt boot.

Thanks
Kishon
