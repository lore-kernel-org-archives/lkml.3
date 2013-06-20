Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab3FTMat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:30:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44037 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3FTMar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:30:47 -0400
Message-ID: <51C2F5DA.1010904@ti.com>
Date: Thu, 20 Jun 2013 15:30:18 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: <stern@rowland.harvard.edu>, <tony@atomide.com>, <balbi@ti.com>,
        <ruslan.bilovol@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC PATCH 2/6] mfd: omap-usb-host: Put pins in IDLE state on
 suspend
References: <1371650753-11452-1-git-send-email-rogerq@ti.com> <1371650753-11452-3-git-send-email-rogerq@ti.com> <878v26815g.fsf@linaro.org>
In-Reply-To: <878v26815g.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 08:23 PM, Kevin Hilman wrote:
> Hi Roger,
> 
> Roger Quadros <rogerq@ti.com> writes:
> 
>> In order to support wake up from suspend use the pinctrl
>> framework to put the USB host pins in IDLE state during suspend.
>>
>> CC: Samuel Ortiz <sameo@linux.intel.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> You should use helpers for this now in the pinctrl core:
> 
>     http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/173514.html
>

Right. thanks.

cheers,
-roger
