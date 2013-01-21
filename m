Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3AUJg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:36:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:55086 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab3AUJg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:36:27 -0500
Message-ID: <50FD0BEF.9000007@ti.com>
Date: Mon, 21 Jan 2013 11:35:43 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: <sameo@linux.intel.com>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Rajendra Nayak <rnayak@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Mike Turquette <mturquette@linaro.com>
Subject: Re: [PATCH v8 19/22] ARM: OMAP3: clock data: get rid of unused USB
 host clock aliases and dummies
References: <1358511445-26656-1-git-send-email-rogerq@ti.com> <1358511445-26656-20-git-send-email-rogerq@ti.com> <alpine.DEB.2.00.1301182027040.19470@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1301182027040.19470@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 10:27 PM, Paul Walmsley wrote:
> Hi Roger,
> 
> On Fri, 18 Jan 2013, Roger Quadros wrote:
> 
>> We don't need multiple aliases for the OMAP USB host clocks and neither
>> the dummy clocks so remove them.
>>
>> CC: Paul Walmsley <paul@pwsan.com>
>> CC: Rajendra Nayak <rnayak@ti.com>
>> CC: Benoit Cousson <b-cousson@ti.com>
>> CC: Mike Turquette <mturquette@linaro.com>
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> Reviewed-by: Felipe Balbi <balbi@ti.com>
>> Acked-by: Paul Walmsley <paul@pwsan.com>
> 
> Per Tony's earlier request, you can drop this patch and patch 20 from your 
> series now.  I've got them queued for 3.10 or late 3.9 merge window.
> 

Should have mentioned it earlier, but just this patch without the rest
of the cleanup patches will break USB Host on OMAP3, as the old driver
bails out if optional clock nodes are missing.

Including patch 20 doesn't seem to cause a problem with OMAP4 though.

regards,
-roger
