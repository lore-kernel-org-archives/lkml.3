Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab3INRBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 13:01:31 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1661 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab3INRBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 13:01:30 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <5234965F.3050404@broadcom.com>
Date: Sat, 14 Sep 2013 19:01:19 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Matt Fleming" <matt.fleming@intel.com>, linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: access efi variables
References: <52333139.6020203@broadcom.com> <5233939B.3020401@zytor.com>
In-Reply-To: <5233939B.3020401@zytor.com>
X-WSS-ID: 7E2A4C602L884776363-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/13 00:37, H. Peter Anvin wrote:
> On 09/13/2013 08:37 AM, Arend van Spriel wrote:
>> I need to obtain a uefi variable so I went looking at the API in
>> include/linux/efi.h. I found the following definition:
>>
>> But according to the specs the variable I need to obtain is 2k bytes.
>> Should I expect trouble :-p
>>
>
> efivarfs doesn't have those limitations.

Thanks, Peter

Looking into efivarfs it seems to use the functions that I looked at in 
efi.h so I guess I am misinterpreting the 1024 bytes limitation in the 
comment (either that or you are mistaken ;-) ). I need to access the 
variable from within a device driver so using efivarfs does not feel 
like the way to go here.

Regards,
Arend

