Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaLZKAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 05:00:07 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44236 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaLZKAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 05:00:03 -0500
Message-ID: <549D31A0.6010301@kernel.org>
Date: Fri, 26 Dec 2014 10:00:00 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Helene Gsaenger <helene.gsaenger@studium.fau.de>
CC: simone.weiss@fau.de, linux-kernel@i4.cs.fau.de, lars@metafoo.de,
        Michael.Hennerich@analog.com, knaack.h@gmx.de, pmeerw@pmeerw.net,
        gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/iio/accel: checkpatch: fixed long lines by moving
 comments
References: <1419211422-9611-1-git-send-email-helene.gsaenger@studium.fau.de> <20141222134851.GA8347@sudip-PC>
In-Reply-To: <20141222134851.GA8347@sudip-PC>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/12/14 13:48, Sudip Mukherjee wrote:
> On Mon, Dec 22, 2014 at 02:23:42AM +0100, Helene Gsaenger wrote:
>> Signed-off-by: Helene Gsaenger <helene.gsaenger@studium.fau.de>
>> Signed-off-by: Simone Weiss <simone.weiss@fau.de>
>> ---
>>  drivers/staging/iio/accel/adis16203.h | 41 ++++++++++++++++++++++++++---------
>>  1 file changed, 31 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/staging/iio/accel/adis16203.h b/drivers/staging/iio/accel/adis16203.h
>> index acc688d..fefe2f9 100644
>> --- a/drivers/staging/iio/accel/adis16203.h
>> +++ b/drivers/staging/iio/accel/adis16203.h
>> @@ -16,26 +16,47 @@
>>  #define ADIS16203_ALM_SMPL2      0x26 /* Alarm 2, sample period */
>>  #define ADIS16203_ALM_CTRL       0x28 /* Alarm control */
>>  #define ADIS16203_AUX_DAC        0x30 /* Auxiliary DAC data */
>> -#define ADIS16203_GPIO_CTRL      0x32 /* General-purpose digital input/output control */
>> +#define ADIS16203_GPIO_CTRL      0x32 /* General-purpose digital input/output
>> +				       * control */
>>  #define ADIS16203_MSC_CTRL       0x34 /* Miscellaneous control */
>> -#define ADIS16203_SMPL_PRD       0x36 /* Internal sample period (rate) control */
>> +#define ADIS16203_SMPL_PRD       0x36 /* Internal sample period (rate)
>> +				       * control */
> 
> this is not the style for multiline comments. Check in CodingStyle.
> and besides, I think it will be better if you can put the comments in a line of its own.
+ remember checkpatch is only for guidance.  Some rules such as the 80 character limit
are often ignored if clarity would be gained by doing so, or if as here a large patch
would be needed (move all comments to separate lines) in order to meet the 80 character
line limit for a couple of cases.
> 
> thanks
> sudip
>>  #define ADIS16203_AVG_CNT        0x38 /* Operation, filter configuration */
>>  #define ADIS16203_SLP_CNT        0x3A /* Operation, sleep mode control */
>>  #define ADIS16203_DIAG_STAT      0x3C /* Diagnostics, system status register */
>>  #define ADIS16203_GLOB_CMD       0x3E /* Operation, system command register */
>>  
>>  /* MSC_CTRL */
>> -#define ADIS16203_MSC_CTRL_PWRUP_SELF_TEST	(1 << 10) /* Self-test at power-on: 1 = disabled, 0 = enabled */
>> -#define ADIS16203_MSC_CTRL_REVERSE_ROT_EN	(1 << 9)  /* Reverses rotation of both inclination outputs */
>> +#define ADIS16203_MSC_CTRL_PWRUP_SELF_TEST	(1 << 10) /* Self-test at
>> +							   * power-on:
>> +							   * 1 = disabled,
>> +							   * 0 = enabled */
>> +#define ADIS16203_MSC_CTRL_REVERSE_ROT_EN	(1 << 9)  /* Reverses rotation
>> +							   * of both
>> +							   * inclination
>> +							   * outputs */
>>  #define ADIS16203_MSC_CTRL_SELF_TEST_EN	        (1 << 8)  /* Self-test enable */
>> -#define ADIS16203_MSC_CTRL_DATA_RDY_EN	        (1 << 2)  /* Data-ready enable: 1 = enabled, 0 = disabled */
>> -#define ADIS16203_MSC_CTRL_ACTIVE_HIGH	        (1 << 1)  /* Data-ready polarity: 1 = active high, 0 = active low */
>> -#define ADIS16203_MSC_CTRL_DATA_RDY_DIO1	(1 << 0)  /* Data-ready line selection: 1 = DIO1, 0 = DIO0 */
>> +#define ADIS16203_MSC_CTRL_DATA_RDY_EN	        (1 << 2)  /* Data-ready enable:
>> +							   * 1 = enabled,
>> +							   * 0 = disabled */
>> +#define ADIS16203_MSC_CTRL_ACTIVE_HIGH	        (1 << 1)  /* Data-ready
>> +							   * polarity:
>> +							   * 1 = active high,
>> +							   * 0 = active low */
>> +#define ADIS16203_MSC_CTRL_DATA_RDY_DIO1	(1 << 0)  /* Data-ready line
>> +							   * selection:
>> +							   * 1 = DIO1,
>> +							   * 0 = DIO0 */
>>  
>>  /* DIAG_STAT */
>> -#define ADIS16203_DIAG_STAT_ALARM2        (1<<9) /* Alarm 2 status: 1 = alarm active, 0 = alarm inactive */
>> -#define ADIS16203_DIAG_STAT_ALARM1        (1<<8) /* Alarm 1 status: 1 = alarm active, 0 = alarm inactive */
>> -#define ADIS16203_DIAG_STAT_SELFTEST_FAIL_BIT 5 /* Self-test diagnostic error flag */
>> +#define ADIS16203_DIAG_STAT_ALARM2        (1<<9) /* Alarm 2 status:
>> +						  * 1 = alarm active,
>> +						  * 0 = alarm inactive */
>> +#define ADIS16203_DIAG_STAT_ALARM1        (1<<8) /* Alarm 1 status:
>> +						  * 1 = alarm active,
>> +						  * 0 = alarm inactive */
>> +#define ADIS16203_DIAG_STAT_SELFTEST_FAIL_BIT 5 /* Self-test diagnostic error
>> +						 * flag */
>>  #define ADIS16203_DIAG_STAT_SPI_FAIL_BIT      3 /* SPI communications failure */
>>  #define ADIS16203_DIAG_STAT_FLASH_UPT_BIT     2 /* Flash update failure */
>>  #define ADIS16203_DIAG_STAT_POWER_HIGH_BIT    1 /* Power supply above 3.625 V */
>> -- 
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

