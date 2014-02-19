Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaBSS3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:29:04 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:59562 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbaBSS3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:29:02 -0500
MIME-Version: 1.0
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AF74107@HASMSX106.ger.corp.intel.com>
References: <20140218205925.11014.14973.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140218205946.11014.13654.stgit@bhelgaas-glaptop.roam.corp.google.com> <5B8DA87D05A7694D9FA63FD143655C1B1AF74107@HASMSX106.ger.corp.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 19 Feb 2014 11:28:39 -0700
Message-ID: <CAErSpo4k9xhDr=NFQdVAvDBtJEMHTKbMqC58iDCVPH5C3tAq=Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] mei: Add include of <linux/irqreturn.h>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        Joerg Roedel <joro@8bytes.org>, "Dutt, Sudeep" <sudeep.dutt@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 1:29 AM, Winkler, Tomas <tomas.winkler@intel.com> wrote:
>
>
>>
>> We currently include <linux/irqreturn.h> in <linux/pci.h>, but I'm about to
>> remove that from linux/pci.h, so add explicit includes where needed.
>>
>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> ---
>>  drivers/misc/mei/hw-me.h |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
>> index 80bd829fbd9a..893d5119fa9b 100644
>> --- a/drivers/misc/mei/hw-me.h
>> +++ b/drivers/misc/mei/hw-me.h
>> @@ -20,6 +20,7 @@
>>  #define _MEI_INTERFACE_H_
>>
>>  #include <linux/mei.h>
>> +#include <linux/irqreturn.h>
>>  #include "mei_dev.h"
>>  #include "client.h"
>
>
> Okay.

Thanks, I added this ack:

Acked-by: Tomas Winkler <tomas.winkler@intel.com>
