Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaDRLdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 07:33:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56733 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaDRLdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 07:33:07 -0400
Message-ID: <53510D59.3000509@ti.com>
Date: Fri, 18 Apr 2014 17:02:41 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <balbi@ti.com>, Grygorii Strashko <grygorii.strashko@ti.com>
CC: <santosh.shilimkar@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] phy: core: make NULL a valid phy reference if !CONFIG_GENERIC_PHY
References: <1397648901-4450-1-git-send-email-grygorii.strashko@ti.com> <20140416151947.GF28035@saruman.home>
In-Reply-To: <20140416151947.GF28035@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wednesday 16 April 2014 08:49 PM, Felipe Balbi wrote:
> On Wed, Apr 16, 2014 at 02:48:21PM +0300, Grygorii Strashko wrote:
>> This fixes a regression on Keystone 2 platforms caused by patch
>> 57303488cd37da58263e842de134dc65f7c626d5
>> "usb: dwc3: adapt dwc3 core to use Generic PHY Framework" which adds
>> optional support of generic phy in DWC3 core.
>>
>> On Keystone 2 platforms the USB is not working now because
>> CONFIG_GENERIC_PHY isn't set and, as result, Generic PHY APIs stubs
>> return -ENOSYS always. The log shows:
>>  dwc3 2690000.dwc3: failed to initialize core
>>  dwc3: probe of 2690000.dwc3 failed with error -38
>>
>> Hence, fix it by making NULL a valid phy reference in Generic PHY
>> APIs stubs in the same way as it was done by the patch
>> 04c2facad8fee66c981a51852806d8923336f362 "drivers: phy: Make NULL
>> a valid phy reference".
>>
>> CC: Kishon Vijay Abraham I <kishon@ti.com>
>> CC: Felipe Balbi <balbi@ti.com>
>> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> I thought I'd already acked this one... oh well, need more coffee:

Indeed.. you acked the v1 of this patch series and already queued the v2 with
your acked by ;-)

Cheers
Kishon

> 
> Acked-by: Felipe Balbi <balbi@ti.com>
> 
