Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaLZJ5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:57:52 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44215 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaLZJ5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:57:46 -0500
Message-ID: <549D3117.6040607@kernel.org>
Date: Fri, 26 Dec 2014 09:57:43 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, knaack.h@gmx.de
CC: lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH 00/10] iio: KMX61 fixes
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/12/14 13:22, Daniel Baluta wrote:
> This is a series of cleanups after Hartmut's review:
> 
> 	* http://marc.info/?l=linux-iio&m=141859700810393&w=2
> 	* http://marc.info/?l=linux-iio&m=141859774010580&w=2
> 	* http://marc.info/?l=linux-iio&m=141859828910703&w=2
> 	* http://marc.info/?l=linux-kernel&m=141868557909385&w=2
> 
> Daniel Baluta (10):
>   iio: imu: kmx61: Save odr_bits for later use
>   iio: imu: kmx61: Don't ignore kmx61_set_power_state errors
>   iio: imu: kmx61: Enhance error handling
>   iio: imu: kmx61: Fixup parameters alignment
>   iio: imu: kmx61: Drop unused device parameter
>   iio: imu: kmx61: Use false instead of 0 for ev_enable_state
>   iio: imu: kmx61: Fix device initialization when setting trigger state
>   iio: imu: kmx61: Remove unnecessary REG_INS1 read
>   iio: imu: kmx61: Drop odr_bits from kmx61_samp_freq_table
>   iio: imu: kmx61: Use correct base when reading data
> 
>  drivers/iio/imu/kmx61.c | 216 ++++++++++++++++++++++--------------------------
>  1 file changed, 101 insertions(+), 115 deletions(-)
> 
Ouch - I need to concentrate more when reviewing!
Anyhow, these all look fine to me, but I'd like to leave them for a few days
for Hartmut to take a look.

Jonathan

