Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaHRMho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:37:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:23379 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbaHRMhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:37:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,885,1400050800"; 
   d="scan'208";a="589639003"
User-Agent: Microsoft-MacOutlook/14.4.3.140616
Date: Mon, 18 Aug 2014 07:37:18 -0500
Subject: Re: [RFC PATCH 1/9] ACPI: Add support for device specific properties
From: Darren Hart <dvhart@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hanjun Guo <hanjun.guo@linaro.org>
CC: "Rafael J. Wysocki" <rafael@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>, <linux-acpi@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <D0175D3C.A1C92%dvhart@linux.intel.com>
Thread-Topic: [RFC PATCH 1/9] ACPI: Add support for device specific properties
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
 <1408255459-17625-2-git-send-email-mika.westerberg@linux.intel.com>
 <53F1B5A9.8060307@linaro.org>
 <20140818082656.GR2462@lahna.fi.intel.com>
In-Reply-To: <20140818082656.GR2462@lahna.fi.intel.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/14, 3:27, "Mika Westerberg" <mika.westerberg@linux.intel.com>
wrote:

>On Mon, Aug 18, 2014 at 04:13:29PM +0800, Hanjun Guo wrote:

Hi Hanjun,

Thanks for reviewing!

>>
>> > +/* ACPI _DSD device properties UUID:
>>daffd814-6eba-4d8c-8a91-bc9bbf4aa301 */
>> > +static const u8 prp_uuid[16] = {
>> 
>> s/prp_uuid/dsd_uuid ?
>
>Well, it is actually the _DSD UUID that implements ACPI device
>properties (hence the prp_) but I have no problems in changing that to
>dsd_uuid instead.

The distinction is important. DSD does not define a format, the UUID does,
and there can be many - although we are adding support specifically for
one. The PRP name here also pairs with the PRP0000 HID.

-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation



