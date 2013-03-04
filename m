Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab3CDTNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:13:23 -0500
Received: from smtp-out-108.synserver.de ([212.40.185.108]:1053 "EHLO
	smtp-out-103.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753079Ab3CDTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:13:22 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13713
Message-ID: <5134F2B9.2060605@metafoo.de>
Date: Mon, 04 Mar 2013 20:15:05 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Guenter Roeck <linux@roeck-us.net>
Subject: Re: linux-next: Tree for Mar 4 (iio)
References: <20130304144358.bd62a57601d4d4793921213e@canb.auug.org.au> <5134EAB7.1040004@infradead.org>
In-Reply-To: <5134EAB7.1040004@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2013 07:40 PM, Randy Dunlap wrote:
> On 03/03/13 19:43, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20130301:
>>
> 
> on x86_64:
> 
> warning: (AD7606 && AD799X_RING_BUFFER && MXS_LRADC && IIO_ADIS_LIB_BUFFER && INV_MPU6050_IIO && HID_SENSOR_ACCEL_3D && AD_SIGMA_DELTA && AD7266 && AD7298 && AD7476 && AD7887 && AT91_ADC && MAX1363 && HID_SENSOR_GYRO_3D && ADJD_S311 && HID_SENSOR_ALS && HID_SENSOR_MAGNETOMETER_3D) selects IIO_TRIGGERED_BUFFER which has unmet direct dependencies (IIO && IIO_BUFFER)
> 
> and then:
> 
> drivers/iio/industrialio-triggered-buffer.c:20:16: error: 'iio_sw_buffer_preenable' undeclared here (not in a function)
> make[3]: *** [drivers/iio/industrialio-triggered-buffer.o] Error 1
> 

Hi,

Thanks for the report. Guenter already fixed the problem last Friday, so the
patch should hopefully show up in next soon.

- Lars
