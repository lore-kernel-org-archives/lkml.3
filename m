Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3A3MtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:49:09 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38036 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab3A3MtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:49:07 -0500
Message-ID: <510916B2.7080509@ti.com>
Date: Wed, 30 Jan 2013 14:48:50 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Mohammed, Afzal" <afzal@ti.com>
CC: "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Balbi, Felipe" <balbi@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "eballetbo@gmail.com" <eballetbo@gmail.com>,
        "javier@dowhile0.org" <javier@dowhile0.org>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <robertcnelson@gmail.com>
Subject: Re: [PATCH v2 00/30] USB: omap-ehci: Move PHY management to PHY driver
References: <1359372631-8180-1-git-send-email-rogerq@ti.com> <C8443D0743D26F4388EA172BF4E2A7A93EA95DF0@DBDE01.ent.ti.com>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EA95DF0@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 02:08 PM, Mohammed, Afzal wrote:
> Hi Roger,
> 
> On Mon, Jan 28, 2013 at 17:00:01, Quadros, Roger wrote:
> 
>> NOTE: Tested on 4460ES-B1 Panda and BeagleBoard C4 only. Other boards are only
>> build tested.
> 
> Please try to ensure that beagle bone USB0 works with this.
> 

Hi Afzal,

I do not have beaglebone with me and don't seem to find beaglebone
board support in mainline.

I would appreciate if someone who knows more about beaglebone can help
with verification.

I could find that Robert C Nelson (now in cc) is maintaining out of tree
patches for the beaglebone. Maybe he could help with verification?

regards,
-roger
