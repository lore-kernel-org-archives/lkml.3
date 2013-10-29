Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab3J2S3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:29:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:6406 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab3J2S26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:28:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="400561255"
Message-ID: <526FFF6A.4020902@linux.intel.com>
Date: Tue, 29 Oct 2013 11:33:14 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: broonie@kernel.org, ning.li@intel.com, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH 2/2] MAINTAINERS: add Intel MID SSP SPI maintainers
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>  <1383069950-27754-2-git-send-email-david.a.cohen@linux.intel.com> <1383070843.12439.14.camel@joe-AO722>
In-Reply-To: <1383070843.12439.14.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 11:20 AM, Joe Perches wrote:
> On Tue, 2013-10-29 at 11:05 -0700, David Cohen wrote:
> []
>> diff --git a/MAINTAINERS b/MAINTAINERS
> []
>> @@ -1916,6 +1916,14 @@ L:	linux-gpio@vger.kernel.org
>>   S:	Maintained
>>   F:	drivers/gpio/gpio-intel-mid.c
>
> Please insert this section in alphabetic order.

It supposed to be. But this patch got messed up with another one.
I'll fix it.

>
>> +INTEL-MID SSP SPI DRIVER
>> +M:	Ning Li <ning.li@intel.com>
>> +M:	David Cohen <david.a.cohen@linux.intel.com>
>> +L:	linux-spi@vger.kernel.org
>> +S:	Maintained
>
> Supported?

Supported from my side but maintained on Ning Li's.
But I can change to supported.

Thanks,

David Cohen
