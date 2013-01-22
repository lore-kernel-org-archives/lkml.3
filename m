Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3AVPlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:41:20 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40318 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab3AVPlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:41:14 -0500
Message-ID: <50FEB309.9040709@ti.com>
Date: Tue, 22 Jan 2013 21:10:57 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Roger Quadros <rogerq@ti.com>, <linux@arm.linux.org.uk>,
        <tony@atomide.com>, <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v1 6/6] USB: MUSB: OMAP: get PHY by phandle for dt boot
References: <1358848694-20145-1-git-send-email-kishon@ti.com> <1358848694-20145-7-git-send-email-kishon@ti.com> <50FE9F5C.2010501@ti.com> <50FEA447.1090701@ti.com> <50FEA696.8000506@ti.com> <50FEAE96.30706@ti.com> <50FEB275.80504@ti.com>
In-Reply-To: <50FEB275.80504@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 22 January 2013 09:08 PM, Peter Ujfalusi wrote:
> On 01/22/2013 04:21 PM, kishon wrote:
>> But it's better to check if deferred probing
>> takes place whenever a new driver is bound to a device as you just mentioned.
>
> Whenever you load (might be also when you unload) a driver the deferred
> modules will try to probe again. This is to check back if the dependency of
> the deferred modules has been fulfilled by the new driver or not.

Thanks Peter.

-Kishon
