Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaLHJ3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:29:15 -0500
Received: from nopam.alitech.com ([202.3.176.31]:45192 "EHLO nopam.alitech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbaLHJ3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:29:13 -0500
X-Greylist: delayed 1912 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2014 04:29:12 EST
split_mail: 1
Message-ID: <548567E3.6020101@alitech.com>
Date: Mon, 08 Dec 2014 09:57:07 +0100
From: Romain Baeriswyl <romain.baeriswyl@alitech.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Shinya Kuribayashi <skuribay@pobox.com>
CC: Christian Ruppert <christian.ruppert@abilis.com>,
        Addy Ke <addy.ke@rock-chips.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: designware: Fix falling time bindings doc
References: <1417805379-8999-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1417805379-8999-1-git-send-email-dianders@chromium.org>
X-MIMETrack: =?Big5?B?SXRlbWl6ZSBieSBTTVRQIFNlcnZlciBvbiBUV0FMSU5TMi9BTElfVFBFL0FMaSg=?=
 =?Big5?B?UmVsZWFzZSA4LjAuMkZQNnxKdWx5IDE1LCAyMDEwKSBhdCAyMDE0LzEyLzA4IKRV?=
 =?Big5?B?pMggMDQ6NTc6NTM=?=,
	=?Big5?B?U2VyaWFsaXplIGJ5IFJvdXRlciBvbiBUV0FMSU5TMi9BTElfVFBFL0FMaSg=?=
 =?Big5?B?UmVsZWFzZSA4LjAuMkZQNnxKdWx5IDE1LCAyMDEwKSBhdCAyMDE0LzEyLzA4IKRV?=
 =?Big5?B?pMggMDQ6NTc6NTU=?=,
	=?Big5?B?U2VyaWFsaXplIGNvbXBsZXRlIGF0IDIwMTQvMTIvMDggpFWkyCAwNDo1Nzo1NQ==?=
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Romain Baeriswyl <romain.baeriswyl@alitech.com>


On 2014-12-05 19:49, Doug Anderson wrote:
> In (6468276 i2c: designware: make SCL and SDA falling time
> configurable) new device tree properties were added for setting the
> falling time of SDA and SCL.  The device tree bindings doc had a typo
> in it: it forgot the "-ns" suffix for both properies in the prose of
> the bindings.
>
> I assume this is a typo because:
> * The source code includes the "-ns"
> * The example in the bindings includes the "-ns".
>
> Fix the typo.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Fixes: 6468276b2206 ("i2c: designware: make SCL and SDA falling time configurable")
> ---
>   Documentation/devicetree/bindings/i2c/i2c-designware.txt | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-designware.txt b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> index 5199b0c..fee26dc 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> +++ b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> @@ -14,10 +14,10 @@ Optional properties :
>    - i2c-sda-hold-time-ns : should contain the SDA hold time in nanoseconds.
>      This option is only supported in hardware blocks version 1.11a or newer.
>
> - - i2c-scl-falling-time : should contain the SCL falling time in nanoseconds.
> + - i2c-scl-falling-time-ns : should contain the SCL falling time in nanoseconds.
>      This value which is by default 300ns is used to compute the tLOW period.
>
> - - i2c-sda-falling-time : should contain the SDA falling time in nanoseconds.
> + - i2c-sda-falling-time-ns : should contain the SDA falling time in nanoseconds.
>      This value which is by default 300ns is used to compute the tHIGH period.
>
>   Example :
>

