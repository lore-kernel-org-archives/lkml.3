Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaCJJP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:15:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47679 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752915AbaCJJP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:15:56 -0400
Message-ID: <531D82CA.3090105@free-electrons.com>
Date: Mon, 10 Mar 2014 10:15:54 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: akpm@linux-foundation.org, joe@perches.com, gregkh@linuxfoundation.org,
        davem@davemloft.net, m.chehab@samsung.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: remove invalid IBM ServeRAID RAID maintainer
 address
References: <1394441655-8257-1-git-send-email-michael.opdenacker@free-electrons.com> <20140310100558.72cb750a@endymion.delvare>
In-Reply-To: <20140310100558.72cb750a@endymion.delvare>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

Thank you for reviewing my patch!

On 03/10/2014 10:05 AM, Jean Delvare wrote:
> Hi Michael,
>
> On Mon, 10 Mar 2014 09:54:15 +0100, Michael Opdenacker wrote:
>> Mail server reply:
>> Recipient address rejected: User unknown in virtual alias table
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
>> ---
>>  MAINTAINERS | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index b7befe758429..52ca18df1707 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -4297,7 +4297,6 @@ X:	drivers/scsi/ibmvscsi/ibmvstgt.c
>>  
>>  IBM ServeRAID RAID DRIVER
>>  P:	Jack Hammer
> A name without an address isn't quite useful (this field is obsolete.)
>
>> -M:	Dave Jeffery <ipslinux@adaptec.com>
>>  W:	http://www.developer.ibm.com/welcome/netfinity/serveraid.html
> This URL doesn't work for me.
>
>>  S:	Supported
> Which makes the validity of this claim rather dubious. I'd suggest you
> remove the P and W fields change S to Orphaned.
>
>>  F:	drivers/scsi/ips.*
This all makes sense to me. I'll send an update.

Thanks again,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

