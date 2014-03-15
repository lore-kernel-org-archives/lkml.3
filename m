Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbaCOPjq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 11:39:46 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60423 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbaCOPjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 11:39:44 -0400
Message-ID: <5324747A.8030507@kernel.org>
Date: Sat, 15 Mar 2014 15:40:42 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Marek Belisko <marek@goldelico.com>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCHv3 8/9] iio: documentation: Add ABI documentation for *_mean_raw
References: <1394472329-15485-1-git-send-email-sre@debian.org> <1394472329-15485-9-git-send-email-sre@debian.org>
In-Reply-To: <1394472329-15485-9-git-send-email-sre@debian.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/14 17:25, Sebastian Reichel wrote:
> Add ABI documentation for in_*_mean_raw files, which are
> already supported and used in the kernel for some time.
>
> Signed-off-by: Sebastian Reichel <sre@debian.org>
As this one stands fine on it's own...

Applied to the togreg branch of iio.git

Thanks
> ---
>   Documentation/ABI/testing/sysfs-bus-iio | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index 6e02c50..58ba333 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -210,6 +210,14 @@ Contact:	linux-iio@vger.kernel.org
>   Description:
>   		Scaled humidity measurement in milli percent.
>
> +What:		/sys/bus/iio/devices/iio:deviceX/in_X_mean_raw
> +KernelVersion:	3.5
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Averaged raw measurement from channel X. The number of values
> +		used for averaging is device specific. The converting rules for
> +		normal raw values also applies to the averaged raw values.
> +
>   What:		/sys/bus/iio/devices/iio:deviceX/in_accel_offset
>   What:		/sys/bus/iio/devices/iio:deviceX/in_accel_x_offset
>   What:		/sys/bus/iio/devices/iio:deviceX/in_accel_y_offset
>

