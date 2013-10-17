Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab3JQXAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 19:00:10 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:42869 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3JQXAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 19:00:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-Ljxqw2QGG2hS+x7J99_HJgezo94YxOkhvGiPh_1qZ-_A@mail.gmail.com>
References: <525d89e8.CwG1bICTvwrMEEOp%fengguang.wu@intel.com>
	<CAK5ve-K41dCLhQnbicqobU889WKe2dGUCJ4Tqy4f_w-F4p27eQ@mail.gmail.com>
	<CAK5ve-+tr5GWg7JSOVF3BB17f+i2Eg57dtm4+Gp9ZzRE+L0Vuw@mail.gmail.com>
	<1381972157-14563-1-git-send-email-maximilian.guentner@gmail.com>
	<CAK5ve-Ljxqw2QGG2hS+x7J99_HJgezo94YxOkhvGiPh_1qZ-_A@mail.gmail.com>
Date: Fri, 18 Oct 2013 01:00:06 +0200
Message-ID: <CAKSnaaf05mA_TKVpH6iESdRU_4cxNwBs-qW_Prmfrfj+KyK6HQ@mail.gmail.com>
Subject: Re: [PATCH v3] leds: Added driver for the NXP PCA9685 I2C chip
From: =?ISO-8859-1?Q?Maximilian_G=FCntner?= 
	<maximilian.guentner@gmail.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Richard Purdie <rpurdie@rpsys.net>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>, kbuild-all@01.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bryan,

thank you for applying the patch so quickly.

Maximilian

2013/10/18 Bryan Wu <cooloney@gmail.com>:
> On Wed, Oct 16, 2013 at 6:09 PM, Maximilian Güntner
> <maximilian.guentner@gmail.com> wrote:
>> The NXP PCA9685 supports 16 channels/leds using a 12-bit PWM (4095
>> levels of brightness)
>> This driver supports configuration using platform_data.
>>
>> Signed-off-by: Maximilian Güntner <maximilian.guentner@gmail.com>
>> ---
>>  v3:
>>    fixed warnings when running make C=1 CF=-D__CHECK_ENDIAN__:
>>     * replaced u16* by __le16*
>>
>
> OK, replaced the old one in my tree.
>
> Thanks,
> -Bryan
>
