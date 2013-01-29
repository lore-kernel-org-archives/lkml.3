Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab3A2Pdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:33:54 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36136 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757305Ab3A2Pdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:33:51 -0500
Message-ID: <5107EBCD.8000406@ti.com>
Date: Tue, 29 Jan 2013 17:33:33 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 10/30] USB: ehci-omap: Use PHY APIs to get the PHY
 device and put it out of suspend
References: <Pine.LNX.4.44L0.1301291026020.1507-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1301291026020.1507-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 05:30 PM, Alan Stern wrote:
> On Tue, 29 Jan 2013, Roger Quadros wrote:
> 
>> For each port that is in PHY mode we obtain a PHY device using the USB PHY
>> library and put it out of suspend.
>>
>> It is up to platform code to associate the PHY to the controller's
>> port and it is upto the PHY driver to manage the PHY's resources.
> 
> s/upto/up to/
> 
>> Also remove wired spacing around declarations we come across.
> 
> s/wired/weird/ -- not that people care about misspellings in the 
> Changelog.  You don't have to resubmit the patch just to fix these two 
> items.
> 
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 

Thanks Alan. I'll fix them in the pull request.

cheers,
-roger
