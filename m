Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbaGSKp7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 06:45:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:45592 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758166AbaGSKp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 06:45:58 -0400
Message-ID: <53CA4CF1.5030504@kernel.org>
Date: Sat, 19 Jul 2014 11:48:17 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Reyad Attiyat <reyad.attiyat@gmail.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH v6 0/4] iio: Add support for rotation from north
References: <1405621109-21147-1-git-send-email-reyad.attiyat@gmail.com>
In-Reply-To: <1405621109-21147-1-git-send-email-reyad.attiyat@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/14 19:18, Reyad Attiyat wrote:
> This series of patches modifies magn-3d driver to handle the rotation
> from north usage. This is done by scanning the report and then building
> the iio arrays (vals and channels) dynamically.
>
> Changes from V5
> - Fix kernel panics from dereference
>
> Reyad Attiyat (4):
>    iio: Documentation: Add documentation for rotation from north sensor
>      usage attributes
>    iio: types: Added support for rotation from north usage attributes
>    iio: hid-sensor-magn-3d: Scan for usage attributes before setting up
>      iio channels
>    iio: hid-sensor-magn-3d: Add support for rotation from north
>
>   Documentation/ABI/testing/sysfs-bus-iio       |  82 +++++++++++
>   drivers/iio/industrialio-core.c               |   4 +
>   drivers/iio/magnetometer/hid-sensor-magn-3d.c | 199 ++++++++++++++++++++------
>   include/linux/iio/types.h                     |   4 +
>   4 files changed, 245 insertions(+), 44 deletions(-)
>
I'm happy enough with this series, but would like an ack or reviewed by
from Srinivas before taking it.

Thanks,

Jonathan
