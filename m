Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbaDLQzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 12:55:53 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44266 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaDLQzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 12:55:51 -0400
Message-ID: <53497066.9000200@kernel.org>
Date: Sat, 12 Apr 2014 17:57:10 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 6/6] iio: Added ABI description for quaternion
References: <1397004988-31550-1-git-send-email-srinivas.pandruvada@linux.intel.com> <1397004988-31550-6-git-send-email-srinivas.pandruvada@linux.intel.com>
In-Reply-To: <1397004988-31550-6-git-send-email-srinivas.pandruvada@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/14 01:56, Srinivas Pandruvada wrote:
> Added documentation for reading quaternion components for 3D rotations.
>
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Your quaternion description doesn't really include all the nuances of
quaternions, but will do the job without confusing anyone ;)
(no particularly reason that we have to get a unit quaternion for example)
> ---
>   Documentation/ABI/testing/sysfs-bus-iio | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index 6e02c50..d1cad9a 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -891,3 +891,12 @@ Contact:	linux-iio@vger.kernel.org
>   Description:
>   		This attribute is used to get/set the integration time in
>   		seconds.
> +
> +What:		/sys/bus/iio/devices/iio:deviceX/in_rot_quaternion_raw
> +KernelVersion:	3.15
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Raw value of quaternion components using a format
> +		x y z w. Here x, y, and z component represents the axis about
> +		which a rotation will occur and w component represents the
> +		amount of rotation.
>

