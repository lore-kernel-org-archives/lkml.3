Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab3DVHK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 03:10:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35105 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab3DVHK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 03:10:58 -0400
Message-ID: <5174E27B.5090808@ti.com>
Date: Mon, 22 Apr 2013 10:10:51 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <b-cousson@ti.com>, <nm@ti.com>, <paul@pwsan.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, "B, Ravi" <ravibabu@ti.com>
Subject: Re: [PATCH v3 0/4] ARM: dts: Add USB host support for Panda and Beagle-xm
References: <1366365457-28972-1-git-send-email-rogerq@ti.com> <20130419154321.GG10155@atomide.com>
In-Reply-To: <20130419154321.GG10155@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 06:43 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [130419 03:02]:
>> Hi Benoit/Tony
>>
>> I've consolidated all the USB host device tree patches for Panda and Beagles
>> to one place and addressed Tony's comments.
>>
>> NOTE: patch 1 depends on OMAP clock binding introduced in
>> https://lkml.org/lkml/2013/4/12/407
>>
>> v3:
>> - updated mux mode to use pulldowns on panda as non-DT boot uses pulldowns.
>> - fixed usb pin naming for panda, beagle and beagle-xm
> 
> Cool. Sounds like we should be able to make omap4 DT only for v3.11

when we say DT only for 3.11, does this mean getting rid of hwmod dependency?

> then. For that we also need USB on 4430-sdp working, but it now
> does:
> 
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> ehci-omap 4a064c00.ehci: failed to get phys phandle in /ocp/usbhshost@4a064000/ehci@4a064c00 node
> ehci-omap 4a064c00.ehci: failed to get phys phandle in /ocp/usbhshost@4a064000/ehci@4a064c00 node
> ...

4430-sdp (Blaze) does not have EHCI USB Host port. It should be using the 
MUSB OTG port.
> 
> As I have mine in a rack I don't have anything plugged into the
> USB port there though, but sounds like the phy is not initialized?
> 

+Ravi B.
He might have some clues.

cheers,
-roger
