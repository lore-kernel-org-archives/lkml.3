Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab3GKQIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:08:37 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:39511
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755817Ab3GKQIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:08:35 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I936eI1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
X-WSS-ID: 0MPS4U1-01-L68-02
X-M-MSG: 
Message-ID: <51DED879.6050200@amd.com>
Date: Thu, 11 Jul 2013 11:08:25 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: <dwmw2@infradead.org>, <sherry.hurwitz@amd.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 V2] linux-firmware: Add AMD microcode patch firmware
 files
References: <1373503376-5841-1-git-send-email-suravee.suthikulpanit@amd.com> <1373504502.24446.49.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1373504502.24446.49.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/2013 8:01 PM, Ben Hutchings wrote:
> I've applied this, but:
>
> On Wed, 2013-07-10 at 19:42 -0500, suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>
>> For AMD Families 10h ~ 14h Processors
>> file:   amd-ucode/microcode_amd.bin
>> md5sum: 55ae79b82cbfddcf7142058be3c9ec2d
>>
>> For AMD Family 15h Processors
>> file:   amd-ucode/microcode_amd_fam15h.bin
>> md5sum: 122ac7e56442c2b7c28eb26978b2d57c
>>
>> Version: 07_10_2013
> This is not a suitable version format, as e.g. 01_01_2014 would be a
> later version but will sort earlier.  When dates are used as versions,
> they should be written in ISO 8601 order, yyyy-mm-dd.  Old releases from
> amd64.org were labelled that way.
Ah.  I'll use different format next time.
> Also, the version belongs in WHENCE, so I added this to WHENCE:
>
> Version: 2013-07-10
Thank you for adding this.
>
>> Signed-off-by: Sherry Hurwitz <sherry.hurwitz@amd.com>
>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>
>> ---
>>
>> Key Name        = AMD Microcode Signing Key (for signing microcode container files only)
>> Key ID          = 8C0108B4
>> Key Fingerprint = 916A 7708 23A7 B27A ADE0  1565 A5E8 DBC9 8C01 08B4
>>
>> GnuPG Signature for file : microcode_amd.bin.asc
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG v1.4.11 (GNU/Linux)
>>
>> iQEcBAABAgAGBQJR3dkLAAoJEKXo28mMAQi0/9cIAKraXlbchZkkIPzyMrZBZZJe
>> zapMterpLdDYL6zukfqgF7Frg94+ilGPK9yKAFsvC+EJyHrF5lbRQ/JthANdRv+Y
>> 8sBKz5/knVI72WdjSjg+473I1rFdIUK+YN7Ygp6eAwP3fg/IQ9UD9iQfWKbbUnx0
>> WSEMCZm/izsyU2LQMJvtizJ2gz9ktFoALUtTvj0bv34CKr++qqngEVFy/WKQdR6x
>> R3l5MjFAhvzO0O9gV59s1tXbPU56HRhMbvSBn3NIVZu17pwAFySHwQLAeW10GH0j
>> UfgpKQppbz90iLLaSh8vseTOoTBn5SegDtK0JEJNMOuK1VoZ+kgv0cqGCs17HBQ=
>> =FnHv
>> -----END PGP SIGNATURE-----
>>
>> GnuPG Signature for file : microcode_amd_fam15h.bin.asc
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG v1.4.11 (GNU/Linux)
>>
>> iQEcBAABAgAGBQJR3dkfAAoJEKXo28mMAQi0iTsIAJ5nCgz/+jFYag2W/OH+kOQe
>> BDXYSC5diXQR5wF/HUkXWh0sl+jNK/OrRVxT7sFaEgAUhEXhK6Df/h7qnJAYQGFr
>> 5+CKhfSr/0Qbk1ziWYAXVKMOXbuLWSSIov1SCcwLsps7A7puITK6xDemLby7KDGC
>> xCUfKIM/BO6DyFpNhKQ+xJdDi+yVxUKQhbdk/8gY94VdUnVZq3CTK9UStpBuaXu0
>> qJNfhbaU+OzgZmnmLq5+xGsCML1xfbgF6sexVRx7oT/Jv30tm97YQJWR0h4DU7jU
>> zjID8kGtYRVV7+i8jC+jVpFo21yDVUkHUcqtNXXRB/lbOYFAm+UJviAEc4NEdSw=
>> =JaWY
>> -----END PGP SIGNATURE-----
> [...]
>
> I added the detached signatures to the commit as separate files, so that
> distributions and other downstream users can verify the signatures.
> linux-firmware.git itself is not currently being tagged, with or without
> signatures.  Please include detached signatures in future.
>
> Ben.
>
We will do so.

Thank you,
Suravee


