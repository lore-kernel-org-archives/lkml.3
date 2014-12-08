Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaLHNyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:54:20 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:57701 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbaLHNyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:54:18 -0500
Message-ID: <5485AD63.6090308@st.com>
Date: Mon, 8 Dec 2014 14:53:39 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee.jones@linaro.org>
Cc: <devicetree@vger.kernel.org>, <kernel@stlinux.com>,
        <linux-kernel@vger.kernel.org>, <linux-spi@vger.kernel.org>,
        <broonie@kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [STLinux Kernel] [PATCH v3 0/4] spi: st: New driver for ST's
 SPI Controller
References: <1418043214-14324-1-git-send-email-lee.jones@linaro.org> <11694915.sCOqLZA7N1@wuerfel>
In-Reply-To: <11694915.sCOqLZA7N1@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-08_01:2014-12-08,2014-12-07,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/08/2014 02:22 PM, Arnd Bergmann wrote:
> On Monday 08 December 2014 12:53:30 Lee Jones wrote:
>> This is a new driver which controls the SPI component of ST's
>> Synchronous Serial Controller (SSC).
>>
> How does this related to the i2c driver for drivers/i2c/busses/i2c-st.c?
> Could you have the same piece of hardware do one or the other mode
> depending on pin configuration, or is each instance hardwired to
> a particular mode?
This is the same IP, that can be configured either in SPI or I2C.

>
> Is there any code worth sharing between the two drivers?
No, except a couple of registers, they are managed in a ways.

The way it is used, a single SSC instance can only be used either in SPI 
or I2C mode on a board,
so I think it wouldn't make sense to create a MFD driver to manage it.

Kr,
Maxime
>
> 	Arnd
>
> _______________________________________________
> Kernel mailing list
> Kernel@stlinux.com
> http://www.stlinux.com/mailman/listinfo/kernel

