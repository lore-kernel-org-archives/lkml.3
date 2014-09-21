Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaIUNDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 09:03:19 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49247 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaIUNDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 09:03:17 -0400
Message-ID: <541ECC92.6030207@kernel.org>
Date: Sun, 21 Sep 2014 14:03:14 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, IIO <linux-iio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
CC: Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v4 3/3] iio: add documentation for current attribute
References: <1410912715-25903-1-git-send-email-jacob.jun.pan@linux.intel.com> <1410912715-25903-4-git-send-email-jacob.jun.pan@linux.intel.com>
In-Reply-To: <1410912715-25903-4-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/09/14 01:11, Jacob Pan wrote:
> Add documentation for input current raw sysfs attribute.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Applied to the togreg branch of iio.git
(initially pushed out as testing for autobuilders to play - though
obviously they aren't going to do much with this patch!)

Jonathan
> ---
>  Documentation/ABI/testing/sysfs-bus-iio | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index d760b02..1ac9ac2 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -1028,3 +1028,12 @@ Contact:	linux-iio@vger.kernel.org
>  Description:
>  		Raw value of rotation from true/magnetic north measured with
>  		or without compensation from tilt sensors.
> +
> +What:		/sys/bus/iio/devices/iio:deviceX/in_currentX_raw
> +KernelVersion:	3.18
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Raw current measurement from channel X. Units are in milliamps
> +		after application of scale and offset. If no offset or scale is
> +		present, output should be considered as processed with the
> +		unit in milliamps.
> 
