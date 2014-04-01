Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaDADV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:21:26 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:47353 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaDADVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:21:25 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s313KmPj022624, This message is accepted by code: ctloc85258
Message-ID: <533A3080.2020008@realtek.com>
Date: Tue, 1 Apr 2014 11:20:32 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <driverdev-devel@linuxdriverproject.org>, <wei_wang@realsil.com.cn>,
        <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v5 3/3] memstick: Add realtek USB memstick host driver
References: <1395744293-24398-1-git-send-email-rogerable@realtek.com> <1395744293-24398-4-git-send-email-rogerable@realtek.com>
In-Reply-To: <1395744293-24398-4-git-send-email-rogerable@realtek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 06:44 PM, rogerable@realtek.com wrote:
> From: Roger Tseng <rogerable@realtek.com>
>
> Realtek USB memstick host driver provides memstick host support based on the
> Realtek USB card reader MFD driver.
>
> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> ---
>   drivers/memstick/host/Kconfig       |  10 +
>   drivers/memstick/host/Makefile      |   1 +
>   drivers/memstick/host/rtsx_usb_ms.c | 839 ++++++++++++++++++++++++++++++++++++
>   3 files changed, 850 insertions(+)
>   create mode 100644 drivers/memstick/host/rtsx_usb_ms.c
Hi Andrew,

Since I'll have to send next revision(v6, to modify patch 1/3) and 
you've commented v4, would you also comment or Ack the 3/3 of this one? 
This should save one revision for me to make any necessary change.
