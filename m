Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab3ARJqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 04:46:07 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55714 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3ARJqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 04:46:03 -0500
Message-ID: <50F919BF.9050109@ti.com>
Date: Fri, 18 Jan 2013 11:45:35 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Alan Stern <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <sameo@linux.intel.com>, <kishon@ti.com>, <sshtylyov@mvista.com>,
        <bjorn@mork.no>, <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/22] mfd: omap-usb-host: Consolidate OMAP USB-HS
 platform data
References: <1358422231-24736-2-git-send-email-rogerq@ti.com> <Pine.LNX.4.44L0.1301171016090.1339-100000@iolanthe.rowland.org> <20130117165943.GI14149@atomide.com>
In-Reply-To: <20130117165943.GI14149@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 06:59 PM, Tony Lindgren wrote:
> * Alan Stern <stern@rowland.harvard.edu> [130117 07:19]:
>> On Thu, 17 Jan 2013, Roger Quadros wrote:
>>
>>> Let's have a single platform data structure for the OMAP's High-Speed
>>> USB host subsystem instead of having 3 separate ones i.e. one for
>>> board data, one for USB Host (UHH) module and one for USB-TLL module.
>>>
>>> This makes the code much simpler and avoids creating multiple copies of
>>> platform data.
>>>
>>> CC: Alan Stern <stern@rowland.harvard.edu>
>>>
>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>
>> For the ehci-omap.c part:
>>
>> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> If Samuel acks this patch, I can apply just this patch alone on v3.8-rc3
> into an immutable branch omap-for-v3.9/board-usb so we all merge it in
> as needed.
> 

I'll be sending a v8 of this series with one stable patch candidate
before this patch and Felipe's comments addressed.

--
cheers,
-roger

