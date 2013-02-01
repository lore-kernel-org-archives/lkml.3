Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab3BAOby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 09:31:54 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60169 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328Ab3BAObw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 09:31:52 -0500
Message-ID: <510BD1CA.9020309@ti.com>
Date: Fri, 1 Feb 2013 16:31:38 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Mohammed, Afzal" <afzal@ti.com>
CC: "Balbi, Felipe" <balbi@ti.com>, "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "eballetbo@gmail.com" <eballetbo@gmail.com>,
        "javier@dowhile0.org" <javier@dowhile0.org>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "robertcnelson@gmail.com" <robertcnelson@gmail.com>
Subject: Re: [PATCH v2 00/30] USB: omap-ehci: Move PHY management to PHY driver
References: <1359372631-8180-1-git-send-email-rogerq@ti.com> <C8443D0743D26F4388EA172BF4E2A7A93EA95DF0@DBDE01.ent.ti.com> <510916B2.7080509@ti.com> <20130130131504.GU15258@arwen.pp.htv.fi> <C8443D0743D26F4388EA172BF4E2A7A93EA95E97@DBDE01.ent.ti.com> <C8443D0743D26F4388EA172BF4E2A7A93EA9FF9C@DBDE01.ent.ti.com> <510BD04A.4000909@ti.com> <C8443D0743D26F4388EA172BF4E2A7A93EA9FFD5@DBDE01.ent.ti.com>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EA9FFD5@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 04:27 PM, Mohammed, Afzal wrote:
> Hi Roger,
> 
> On Fri, Feb 01, 2013 at 19:55:14, Quadros, Roger wrote:
> 
>> Thanks Afzal :). You mean the non device tree boot right?
> 
> No, dt boot, am335x can only dt boot.

but DT boot is not supported for OMAP USB Host. How did you get it to work?

Are you testing the Host connector or the OTG connector?

regards,
-roger

