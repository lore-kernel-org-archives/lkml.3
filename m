Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007Ab3HIPYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:24:16 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:44715
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934350Ab3HIPYL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:24:11 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Ic89bh8d0I936eI70dI1432Idbb0idbf2izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1d7338h1de098h17326ah1de096h1d68deh8275bh8275dh1de097hz2dh668h839h93fhe5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1889i1155h)
X-WSS-ID: 0MR9S43-02-3HU-02
X-M-MSG: 
Message-ID: <52050993.80502@amd.com>
Date: Fri, 9 Aug 2013 10:24:03 -0500
From: Sherry Hurwitz <sherry.hurwitz@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: David Woodhouse <dwmw2@infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] linux-firmware/AMD: add readme files for amd-ucode
References: <1374273832-5228-1-git-send-email-sherry.hurwitz@amd.com> <1375992837.2853.78.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1375992837.2853.78.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 03:13 PM, Ben Hutchings wrote:
> I don't think this documentation is currently very useful.  See further
> comments inline:
>
> On Fri, 2013-07-19 at 17:43 -0500, Sherry Hurwitz wrote:
>> File: README
>> File: microcode_amd.bin.README
>> File: microcode_amd_fam15h.bin.README
>>
>> Signed-off-by: Sherry Hurwitz <sherry.hurwitz@amd.com>
>> ---
>>   amd-ucode/README                          |   46 +++++++++++++++++++++++++++++
>>   amd-ucode/microcode_amd.bin.README        |   29 ++++++++++++++++++
>>   amd-ucode/microcode_amd_fam15h.bin.README |   13 ++++++++
>>   3 files changed, 88 insertions(+)
>>   create mode 100644 amd-ucode/README
>>   create mode 100644 amd-ucode/microcode_amd.bin.README
>>   create mode 100644 amd-ucode/microcode_amd_fam15h.bin.README
>>
>> diff --git a/amd-ucode/README b/amd-ucode/README
>> new file mode 100644
>> index 0000000..a92831d
>> --- /dev/null
>> +++ b/amd-ucode/README
>> @@ -0,0 +1,46 @@
>> +This package provides latest microcode patches
>> +for AMD processor families >= 0x10.
>> +
>> +See http://www.amd64.org/support/microcode.html
>> +for details.
> As Marc Dietrich pointed out, this URL is currently broken.
I will remove the reference to the URL.
>
>> +Microcode patches are included in container files:
>> +- 'microcode_amd.bin' (for AMD CPU families 10h - 14h)
>> +- 'microcode_amd_fam15h.bin' (for AMD CPU family 15h)
>> +
>> +Please read the file INSTALL for install instructions.
>> +Please read the file LICENSE for licensing information.
> These aren't the filenames used in linux-firmware.git.
no the files in linux-firmware.git are container files that hold these 
.asm files which are the true ucode.  This was merely listing what is in 
the container.
>
>> +The container files include following microcode patches:
>> +
>> +    mc_patch_01000083_PUB-v4/mc_patch_01000083.asm
>> +    mc_patch_01000084_PUB-v4/mc_patch_01000084.asm
>> +    mc_patch_010000C7_PUB-v1/mc_patch_010000C7.asm
>> +    mc_patch_010000C8_PUB-v1/mc_patch_010000C8.asm
>> +    mc_patch_010000D9_PUB-v1/mc_patch_010000D9.asm
>> +    mc_patch_010000DA_PUB-v1/mc_patch_010000DA.asm
>> +    mc_patch_010000DB_PUB-v1/mc_patch_010000DB.asm
>> +    mc_patch_010000DC_PUB-v1/mc_patch_010000DC.asm
>> +    mc_patch_02000032_PUB-v3/mc_patch_02000032.asm
>> +    mc_patch_03000027_PUB-v1/mc_patch_03000027.asm
>> +    mc_patch_05000029_PUB-v1/mc_patch_05000029.asm
>> +    mc_patch_05000119_PUB-v1/mc_patch_05000119.asm
>> +    mc_patch_0600063D_PUB-v1/mc_patch_0600063D.asm
>> +    mc_patch_06000822_PUB-v1/mc_patch_06000822.asm
>> +    mc_patch_06001119_PUB-v2/mc_patch_06001119.asm
> Are these filenames supposed to be meaningful?  Are they referenced by
> some other documentation?
These names include the patch ID numbers that could be referenced in the 
table showing the list of errata or when talking to AMD support.  I will 
explain that in a better way in a new version of the document
>
>> +***********************************************************************
>> +Copyright 2008-2013 ADVANCED MICRO DEVICES, INC.  All Rights Reserved.
>> +
>> +AMD is granting you permission to use this software and documentation
>> +(if any) (collectively, the “Materials”) pursuant to the terms and
>> +conditions of the Software License Agreement included with the
>> +Materials.  This header does NOT give you permission to use the
>> +Materials or any rights under AMD’s intellectual property.  Your use
>> +of any portion of these Materials shall constitute your acceptance of
>> +those terms and conditions.  If you do not agree to the terms and
>> +conditions of the Software License Agreement, you do not have
>> +permission to use any portion of these Materials.  If you do not have
>> +a copy of the Software License Agreement, contact your AMD
>> +representative for a copy.
>> +
> Isn't this redundant with LICENSE.amd-ucode?
Yes, I will remove this in version 2
>
>> diff --git a/amd-ucode/microcode_amd.bin.README b/amd-ucode/microcode_amd.bin.README
>> new file mode 100644
>> index 0000000..617d951
>> --- /dev/null
>> +++ b/amd-ucode/microcode_amd.bin.README
>> @@ -0,0 +1,29 @@
>> +;******************************************************************************
>> +; The associated microcode container file fixes the errata as documented in
>> +; Revision Guide for AMD Family 10h Processors, order #41322,
>> +; Revision Guide for AMD Family 11h Processors, order #41788,
>> +; Revision Guide for AMD Family 12h Processors, order #44739,
>> +; Revision Guide for AMD Family 14h Models 00h-0Fh Processors, order #47534,
> Where can these be found?  (I found *some* revision guides with a web
> search, but nothing with errata numbers above 400.)
I will include the URL for amd developer central where they can be 
downloaded.
>
>> +; for different revisions of AMD processors as follows:
>> +;
>> +; CPUIDFn[0000_0001]_EAX; ID;         Errata fixed;
>> +;
>> +; 0x00100F22;             0x01000083; 244, 260, 280, 302, 308, 315, 342;
>> +; 0x00100F23;             0x01000083; 244, 260, 280, 302, 308, 315, 342;
>> +; 0x00100F2A;             0x01000084; 244, 260, 280, 302, 308, 315, 342;
>> +; 0x00100F42;             0x010000DB; 342, 440, 573;
>> +; 0x00100F43;             0x010000C8; 407, 440;
>> +; 0x00100F52;             0x010000DB; 342, 440, 573;
>> +; 0x00100F53;             0x010000C8; 407, 440;
>> +; 0x00100F62;             0x010000C7; 407, 440;
>> +; 0x00100F63;             0x010000C8; 407, 440;
>> +; 0x00100F80;             0x010000DA; 419, 440, 573;
>> +; 0x00100F81;             0x010000D9; #406, #407, #440, #573, #669;
>> +; 0x00100F91;             0x010000D9; #406, #407, #440, #573, #669;
>> +; 0x00100FA0;             0x010000DC; 438, 440, 573;
>> +; 0x00200F31;             0x02000032; 311, 316;
>> +; 0x00300F10;             0x03000027; #564, #573, #662, #686;
>> +; 0x00500F10;             0x05000029; #461, #564, #594, #595, #784;
>> +; 0x00500F20;             0x05000119; #461, #564, #594, #639, #662, #686, #784;
>> +;******************************************************************************
> Presumably when I see this in /proc/cpuinfo:
>
> cpu family      : 16
> model           : 6
> model name      : AMD Turion(tm) II Neo N54L Dual-Core Processor
> stepping        : 3
> microcode       : 0x10000c8
>
> this means the relevant line is:
>
>> +; 0x00100F43;             0x010000C8; 407, 440;
> [...]
>
> But can you make the documentation explicit about how to look this up
> based on the information Linux provides?
yes, will add this to the document.
>
> Ben.
>
Regards,
Sherry

