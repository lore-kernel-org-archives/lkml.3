Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3AQMKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:10:35 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58000 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409Ab3AQMKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:10:33 -0500
Message-ID: <50F7EA2A.2080705@ti.com>
Date: Thu, 17 Jan 2013 14:10:18 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <sameo@linux.intel.com>, <tony@atomide.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 15/22] mfd: omap-usb-host: Manage HSIC clocks for HSIC
 mode
References: <1358422231-24736-1-git-send-email-rogerq@ti.com> <1358422231-24736-16-git-send-email-rogerq@ti.com> <20130117114522.GF18978@arwen.pp.htv.fi>
In-Reply-To: <20130117114522.GF18978@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 01:45 PM, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Jan 17, 2013 at 01:30:24PM +0200, Roger Quadros wrote:
>> @@ -598,6 +639,24 @@ static int usbhs_omap_probe(struct platform_device *pdev)
>>  				clkname, PTR_ERR(pclk));
>>  		else
>>  			omap->utmi_clk[i] = pclk;
>> +
>> +		snprintf(clkname, sizeof(clkname),
>> +				"usb_host_hs_hsic480m_p%d_clk", i + 1);
> 
> do we really need to know the exact clock node name ?
> 
I think so. Do you have a better suggestion?

--
cheers,
-roger
