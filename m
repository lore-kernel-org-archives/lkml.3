Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab3AQNab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:30:31 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51734 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3AQNaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:30:30 -0500
Message-ID: <50F7FCDF.7040808@ti.com>
Date: Thu, 17 Jan 2013 15:30:07 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <sameo@linux.intel.com>, <tony@atomide.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 22/22] mdf: omap-usb-host: get rid of build warning
References: <1358422231-24736-1-git-send-email-rogerq@ti.com> <1358422231-24736-23-git-send-email-rogerq@ti.com> <20130117115046.GI18978@arwen.pp.htv.fi>
In-Reply-To: <20130117115046.GI18978@arwen.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 01:50 PM, Felipe Balbi wrote:
> On Thu, Jan 17, 2013 at 01:30:31PM +0200, Roger Quadros wrote:
>> Fixes the below build warning when driver is built-in.
>>
>> drivers/mfd/omap-usb-host.c:750:12: warning:
>> ‘usbhs_omap_remove’ defined but not used [-Wunused-function]
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> should this go to stable too ?
> 
> (though it's not really a bug, so doesn't really matter, I guess).
> 
not a bug so let's not send this to stable.

--
cheers,
-roger
