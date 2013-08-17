Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab3HQT3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 15:29:47 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:59571 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab3HQT3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 15:29:45 -0400
Message-ID: <520FDD33.2070605@kernel.org>
Date: Sat, 17 Aug 2013 21:29:39 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        jic23@cam.ac.uk, denis.ciocca@st.com,
        srinivas.pandruvada@linux.intel.com, lars@metafoo.de
Subject: Re: [PATCH v4 1/2] staging: iio: Documentation sysfs-bus-iio add
 power_mode
References: <1376655125-13421-1-git-send-email-o.v.kravchenko@globallogic.com>
In-Reply-To: <1376655125-13421-1-git-send-email-o.v.kravchenko@globallogic.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/13 13:12, Oleksandr Kravchenko wrote:
> Add description about in_accelX_power_mode and
> in_accel_power_mode_available.
> 
Right now this is very much chip specific so it wants to go in
sysfs-bus-iio-accel-bma180  If / when it turns up in lots of parts
we can discuss whether it is a good general purpose interface
or not.


> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-iio |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index dda81ff..1a333f3 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -792,3 +792,13 @@ Contact:	linux-iio@vger.kernel.org
>  Description:
>  		This attribute is used to read the amount of quadrature error
>  		present in the device at a given time.
> +
> +What:		/sys/.../iio:deviceX/in_accelX_power_mode
> +KernelVersion:	3.11
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Specifies the chip power mode.
> +		low_noise: reduce noise level from ADC,
> +		low_power: enable low current consumption.
> +		For a list of available output power modes read
> +		in_accel_power_mode_available.
> 
