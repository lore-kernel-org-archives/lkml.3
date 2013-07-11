Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab3GKAWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:22:31 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:15660
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753977Ab3GKAWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:22:30 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I936eI1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
X-WSS-ID: 0MPQX1B-01-8ZS-02
X-M-MSG: 
Message-ID: <51DDFABF.4030101@amd.com>
Date: Wed, 10 Jul 2013 19:22:23 -0500
From: Sherry Hurwitz <sherry.hurwitz@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: David Woodhouse <dwmw2@infradead.org>, <linux-kernel@vger.kernel.org>,
        <amd64-microcode@amd64.org>, <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 1/1] linux-firmware: Add AMD microcode patch firmware
 files
References: <1372447651-10290-1-git-send-email-sherry.hurwitz@amd.com> <1372906583.22888.66.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1372906583.22888.66.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2013 09:56 PM, Ben Hutchings wrote:
> On Fri, 2013-06-28 at 14:27 -0500, Sherry Hurwitz wrote:
>> For AMD Families 10h ~ 14h Processors
>> file:   amd-ucode/microcode_amd.bin
>> md5sum: 55ae79b82cbfddcf7142058be3c9ec2d
>>
>> For AMD Family 15h Processors
>> file:   amd-ucode/microcode_amd_fam15h.bin
>> md5sum: 122ac7e56442c2b7c28eb26978b2d57c
>>
>> Signed-off-by: Sherry Hurwitz<sherry.hurwitz@amd.com>
>> ---
>>   LICENSE.amd-ucode                  |   64 ++++++++++++++++++++++++++++++++++++
>>   WHENCE                             |    9 +++++
>>   amd-ucode/microcode_amd.bin        |  Bin 0 -> 12684 bytes
>>   amd-ucode/microcode_amd_fam15h.bin |  Bin 0 -> 7876 bytes
>>   4 files changed, 73 insertions(+)
>>   create mode 100644 LICENSE.amd-ucode
>>   create mode 100644 amd-ucode/microcode_amd.bin
>>   create mode 100644 amd-ucode/microcode_amd_fam15h.bin
> [...]
>> --- a/WHENCE
>> +++ b/WHENCE
>> @@ -2169,3 +2169,12 @@ File: go7007/wis-startrek.fw
>>   Licence: Redistributable. See LICENCE.go7007_firmware for details
>>   
>>   --------------------------------------------------------------------------
>> +
>> +Driver: microcode_amd - AMD CPU Microcode Update Driver for Linux
>> +
>> +File: amd-ucode/microcode_amd.bin
>> +File: amd-ucode/microcode_amd_fam15h.bin
>> +
>> +License: Redistributable. See LICENSE.amd-ucode for details
> [...]
>
> Please include the version number.
>
> I notice that the download page on amd64.org also has GPG signatures.
> Perhaps those should be included too?
>
> (Actually, I would like to see verifiable signatures on all binary
> firmware, but I don't think that can be made a requirement any time
> soon.  Key 9F94BC90 isn't signed by another published key, so I still
> have no reason to trust its identity.)
>
> Ben.
>
The amd64.org site is down and will no longer be used for distributing 
AMD microcode patches.  Therefore, the Key ID 9F94BC90 will no longer be 
used to sign the future microcode container files.  A new key will be 
created and signed by me and another AMD co-worker.  We will resend the 
patch with  the Key ID 8C0108B4.  You can pull this key from the gnuPG 
key server to verify and see it is signed by two other keys, one 
belonging to me and the other by Suravee Suthikulpanit, with AMD email 
addresses.

Sherry


