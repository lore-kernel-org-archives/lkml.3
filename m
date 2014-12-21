Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaLULaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 06:30:11 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34723 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaLULaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 06:30:08 -0500
Message-ID: <5496AF29.3060802@linaro.org>
Date: Sun, 21 Dec 2014 19:29:45 +0800
From: zhangfei <zhangfei.gao@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: kbuild test robot <fengguang.wu@intel.com>
CC: kbuild-all@01.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        "xuwei (O)" <xuwei5@hisilicon.com>
Subject: Re: [PATCH hisi] Input: i2c_atmel_read() can be static
References: <201412190926.IzkyYvvl%fengguang.wu@intel.com> <20141219015659.GA49367@snb.sh.intel.com>
In-Reply-To: <20141219015659.GA49367@snb.sh.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/19/2014 09:56 AM, kbuild test robot wrote:
> drivers/input/touchscreen/atmel_mXT224E.c:460:5: sparse: symbol 'i2c_atmel_read' was not declared. Should it be static?
> drivers/input/touchscreen/atmel_mXT224E.c:496:5: sparse: symbol 'i2c_atmel_write' was not declared. Should it be static?
> drivers/input/touchscreen/atmel_mXT224E.c:532:5: sparse: symbol 'i2c_atmel_write_byte_data' was not declared. Should it be static?
> drivers/input/touchscreen/atmel_mXT224E.c:538:10: sparse: symbol 'get_object_address' was not declared. Should it be static?
> drivers/input/touchscreen/atmel_mXT224E.c:547:9: sparse: symbol 'get_object_size' was not declared. Should it be static?
> drivers/input/touchscreen/atmel_mXT224E.c:557:9: sparse: symbol 'get_object_size_from_address' was not declared. Should it be static?
> drivers/input/touchscreen/atmel_mXT224E.c:847:32: sparse: symbol 'atmel_ts_get_pdata' was not declared. Should it be static?
>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Thanks Fengguang for the patch, will take it.

However, the file drivers/input/touchscreen/atmel_mXT224E.c is not used 
for mainline kernel.

Xuwei will remove git://github.com/hisilicon/linux-hisi 
integration-hilt-linux-linaro.
Sorry for the confusion.

Thanks
