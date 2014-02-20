Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaBTK7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:59:44 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51887 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbaBTK7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:59:42 -0500
Message-ID: <5305E01A.3020905@ti.com>
Date: Thu, 20 Feb 2014 12:59:38 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 0/2] usb: musb: host: fixes for 3.14-rc
References: <1391520349-26192-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1391520349-26192-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

Hope you had a good vacation :).

Could you please take a look at these two fixes? Thanks.

cheers,
-roger

On 02/04/2014 03:25 PM, Roger Quadros wrote:
> Hi Greg,
> 
> Patch 1 fixes SuperSpeed hub enumeration on beaglebone.
> Patch 2 fixes remote-wakeup resume on beaglebone.
> 
> Felipe has Acked the 1st patch but still needs to Ack the 2nd one.
> 
> Patches are based on 3.14-rc1
> 
> cheers,
> -roger
> 
> Ajay Kumar Gupta (1):
>   usb: musb: host: Fix SuperSpeed hub enumeration
> 
> Roger Quadros (1):
>   usb: musb: core: Fix remote-wakeup resume
> 
>  drivers/usb/musb/musb_core.c | 10 +++++++++-
>  drivers/usb/musb/musb_host.c |  3 +++
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 

