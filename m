Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaEGAYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 20:24:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65174 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaEGAYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 20:24:11 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-97-53697d2945dd
Message-id: <53698171.9070501@samsung.com>
Date: Wed, 07 May 2014 09:42:25 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        Russell King <linux@arm.linux.org.uk>, arnd@arndb.de,
        Wolfram Sang <wsa@the-dreams.de>, t.figa@samsung.com,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2 2/6] ARM: EXYNOS: Move SYS_I2C_CFG register save/restore
 to i2c driver
References: <1399366282-4191-1-git-send-email-pankaj.dubey@samsung.com>
 <1399366282-4191-3-git-send-email-pankaj.dubey@samsung.com>
 <53693229.3080705@gmail.com>
In-reply-to: <53693229.3080705@gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zI13N2sxgg5k9lhZ/Jx1jt+hdcJXN
	YtPja6wWHX+/MFpc3jWHzWLG+X1MFrcv81qsn/GaxWLVrj+MFitPzGJ24PJoae5h8/j9axKj
	x85Zd9k9Ni+p9+jbsorR4+SpJywenzfJBbBHcdmkpOZklqUW6dslcGW8/ruaseChbMWuT3sY
	GxjniXcxcnJICJhIbHjWwgphi0lcuLeerYuRi0NIYBmjxJULjSwwRf8OPWCGSCxilPi6p4MV
	wnnNKDGlazEbSBWvgJbEryvnwGwWAVWJny8+gtlsAroST97PZQaxRQXCJDZN72OFqBeU+DH5
	HtgGEQF1iW9T+tlBhjIL9DJJLD8HkuDgEBaIl7i23AZi2RJGic0H/zKBNHAKaErsXXEQrJlZ
	wFpi5aRtjBC2vMTmNW/BTpUQ+MkuMbu1hRHiIgGJb5MPgQ2VEJCV2HSAGeI1SYmDK26wTGAU
	m4XkpllIxs5CMnYBI/MqRtHUguSC4qT0IkO94sTc4tK8dL3k/NxNjJBI7d3BePuA9SHGZKCV
	E5mlRJPzgZGeVxJvaGxmZGFqYmpsZG5pRpqwkjhv0sOkICGB9MSS1OzU1ILUovii0pzU4kOM
	TBycUg2MB8/PcPn9Slb4woV3Va7Mie9Dano6c4Rm2qkbrg43dvd4YzfXc1XEr+Vt00weBV+T
	+fNx77V7b1Zc03zwf0HaPGdB+z2NR0Tn827N47y++8m8wvp6NjFeO5dT+9arvVHvyF1i3bR/
	h9W81RENb99NsdzyL+j32oVS/wSOHXac2/f/u4FOonz7OSWW4oxEQy3mouJEAGwUlDzqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAV3N2sxgg5lfjC3+TjrGbtG74Cqb
	xabH11gtOv5+YbS4vGsOm8WM8/uYLG5f5rVYP+M1i8WqXX8YLVaemMXswOXR0tzD5vH71yRG
	j52z7rJ7bF5S79G3ZRWjx8lTT1g8Pm+SC2CPamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1
	MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6T0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQ
	XI+RARpIWMeY8frvasaCh7IVuz7tYWxgnCfexcjJISFgIvHv0ANmCFtM4sK99WxdjFwcQgKL
	GCW+7ulghXBeM0pM6VrMBlLFK6Al8evKOTCbRUBV4ueLj2A2m4CuxJP3c8EmiQqESWya3scK
	US8o8WPyPRYQW0RAXeLblH52kKHMAr1MEsvPgSQ4OIQF4iWuLbeBWLaEUWLzwb9MIA2cApoS
	e1ccBGtmFrCWWDlpGyOELS+xec1b5gmMArOQ7JiFpGwWkrIFjMyrGEVTC5ILipPSc430ihNz
	i0vz0vWS83M3MYLTwDPpHYyrGiwOMQpwMCrx8Fq8zQgWYk0sK67MPcQowcGsJMJ7UzczWIg3
	JbGyKrUoP76oNCe1+BBjMjAIJjJLiSbnA1NUXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE
	0hNLUrNTUwtSi2C2MHFwSjUwrrPTua2xNL3L8cqhv5N5t7XExRvZr5j2ZJ70vbKS6Ioa2Y1T
	Wd41P/shm99gMHEth+OkpnWGFzlWOXwRvjrF6jzzlokzVipzrX/bWqT/eOf1e3c1Vt08kN1w
	wrW697L/rHx+l/s3eIpK9I73X5l5oTUkYt2FN9/6zn4TDeXazf348Kq9e7ddsFViKc5INNRi
	LipOBAAqbacTRwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 04:04 AM, Tomasz Figa wrote:
> Hi Pankaj,
>
> On 06.05.2014 10:51, Pankaj Dubey wrote:
>> Let's move SYS_I2C_CFG register save/restore during s2r into i2c driver.
>> This will help in removing static iodesc based mapping from exynos.c.
>> Also will help in removing SoC specific checks in pm.c making it
>> more independent of such macros.
>>
>> CC: Wolfram Sang <wsa@the-dreams.de>
>> CC: Russell King <linux@arm.linux.org.uk>
>> CC: linux-i2c@vger.kernel.org
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   arch/arm/mach-exynos/exynos.c           |   12 +-----------
>>   arch/arm/mach-exynos/include/mach/map.h |    3 ---
>>   arch/arm/mach-exynos/pm.c               |   10 ----------
>>   arch/arm/mach-exynos/regs-sys.h         |   22 ----------------------
>>   drivers/i2c/busses/i2c-s3c2410.c        |    8 ++++++++
>>   5 files changed, 9 insertions(+), 46 deletions(-)
>>   delete mode 100644 arch/arm/mach-exynos/regs-sys.h
>
> [snip]
>
>> diff --git a/drivers/i2c/busses/i2c-s3c2410.c 
>> b/drivers/i2c/busses/i2c-s3c2410.c
>> index 0420150..2095a01 100644
>> --- a/drivers/i2c/busses/i2c-s3c2410.c
>> +++ b/drivers/i2c/busses/i2c-s3c2410.c
>> @@ -133,6 +133,7 @@ struct s3c24xx_i2c {
>>       struct notifier_block    freq_transition;
>>   #endif
>>       struct regmap        *sysreg;
>> +    unsigned int        syc_cfg;
>
> I suspect this is a typo, as the name syc_cfg looks a bit strange. 
> Shouldn't it be sys_i2c_cfg?
Oops. Will correct it in next version.
>
>>   };
>>
>>   static struct platform_device_id s3c24xx_driver_ids[] = {
>> @@ -1293,6 +1294,9 @@ static int s3c24xx_i2c_suspend_noirq(struct device 
>> *dev)
>>       struct platform_device *pdev = to_platform_device(dev);
>>       struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
>>
>> +    if (i2c->sysreg)
>
> IS_ERR() should be used.
>
>> +        regmap_read(i2c->sysreg, EXYNOS5_SYS_I2C_CFG, &i2c->syc_cfg);
>
> Aha, so this is where the reference to the regmap gets used outside the 
> probe. I'd say that changes to the i2c driver from this patch should be 
> squashed with previous patch and this patch should contain only arch 
> changes to remove old code.

OK, in next version I will update accordingly.

>
> However, I wonder if this is really the right approach to this, as now 
> you have save and restore duplicated for every instance of s3c24xx-i2c IP 
> block. If there are no bits other than interrupt mux selectors in this 
> registers then I guess this is fine (I can't look it up in the 
> documentation at the moment), but otherwise you can end-up with multiple 
> paths doing read-modify-write to this register in parallel possibly with 
> different values.

SYS_I2C_CFG for exynos5250 has only bits for mux selectors for i2c.

>
> Needless to say, this isn't very elegant, but I'm not opposed too much, 
> as I can't really think of anything better right now.
>
>> +
>>       i2c->suspended = 1;
>>
>>       return 0;
>> @@ -1304,6 +1308,10 @@ static int s3c24xx_i2c_resume(struct device *dev)
>>       struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
>>
>>       i2c->suspended = 0;
>> +
>> +    if (i2c->sysreg)
>> +        regmap_write(i2c->sysreg, i2c->syc_cfg, EXYNOS5_SYS_I2C_CFG);
>> +
>
> I'd say this should be happening before setting i2c->suspended to 0 to 
> account for possible i2c transfers being requested in parallel. Also see 
> patch [1].
>
> [1] https://lkml.org/lkml/2014/4/11/632

OK, will move this before i2c->suspended = 0.

If possible please review other patches also in this series so that I can 
update
whole series with addressing all review comments.

>
> Best regards,
> Tomasz
>


-- 
Best Regards,
Pankaj Dubey

