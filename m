Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab3AQMN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:13:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47009 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab3AQMN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:13:27 -0500
Message-ID: <50F7EAD1.8050107@ti.com>
Date: Thu, 17 Jan 2013 14:13:05 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <sameo@linux.intel.com>, <tony@atomide.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 17/22] mfd: omap-usb-host: clean up omap_usbhs_init()
References: <1358422231-24736-1-git-send-email-rogerq@ti.com> <1358422231-24736-18-git-send-email-rogerq@ti.com> <20130117114804.GG18978@arwen.pp.htv.fi>
In-Reply-To: <20130117114804.GG18978@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 01:48 PM, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Jan 17, 2013 at 01:30:26PM +0200, Roger Quadros wrote:
>> +	if (is_omap_usbhs_rev1(omap))
>> +		reg = omap_usbhs_rev1_hostconfig(omap, reg);
>> +	else if (is_omap_usbhs_rev2(omap))
>> +		reg = omap_usbhs_rev2_hostconfig(omap, reg);
> 
> Any way you could maybe:
> 
> rev = omap_usbhs_revision(omap)
> switch(rev) {
> case REV1:
> 	foo();
> 	break;
> case REV2:
> 	bar();
> 	break;
> default:	/* highest revision */
> 	baz();
> }
> 
> could be done in a later patch however.
> 
I'll fix it in this series.

--
cheers,
-roger
