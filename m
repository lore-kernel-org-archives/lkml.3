Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3H1PBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:01:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:23469 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab3H1PBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:01:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,976,1367996400"; 
   d="scan'208";a="394772185"
Message-ID: <521E1255.2090201@linux.intel.com>
Date: Wed, 28 Aug 2013 08:08:05 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        jic23@cam.ac.uk, denis.ciocca@st.com, lars@metafoo.de
Subject: Re: [PATCH v5 1/2] staging: iio: Documentation sysfs-bus-iio add
 power_mode
References: <1377687678-5761-1-git-send-email-o.v.kravchenko@globallogic.com>
In-Reply-To: <1377687678-5761-1-git-send-email-o.v.kravchenko@globallogic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 04:01 AM, Oleksandr Kravchenko wrote:
> Add description about in_accelX_power_mode and
> in_accel_power_mode_available.
>
> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
> ---
>   Documentation/ABI/testing/sysfs-bus-iio |   10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index dda81ff..1a333f3 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -792,3 +792,13 @@ Contact:	linux-iio@vger.kernel.org
>   Description:
>   		This attribute is used to read the amount of quadrature error
>   		present in the device at a given time.
> +
> +What:		/sys/.../iio:deviceX/in_accelX_power_mode
Shall we add power_mode to all sensors not just accelerometer? HID 
sensor hub spec allows every sensor in it to go low power mode.
This is not same as OFF.
> +KernelVersion:	3.11
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Specifies the chip power mode.
> +		low_noise: reduce noise level from ADC,
> +		low_power: enable low current consumption.
> +		For a list of available output power modes read
> +		in_accel_power_mode_available.

