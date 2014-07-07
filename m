Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaGGMVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:21:20 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:59663 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaGGMVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:21:19 -0400
Message-ID: <53BA90A5.1000108@ahsoftware.de>
Date: Mon, 07 Jul 2014 14:20:53 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] [PATCH 1/2] Allow to override the hctosys RTC using
 a kernel parameter
References: <5132579.sMfE4ssjXf@rfietze>
In-Reply-To: <5132579.sMfE4ssjXf@rfietze>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.07.2014 13:30, schrieb Roman Fietze:
> Hello RTC maintainers and list members,
> 
> I would like to hear your criticism about the following two small
> patches.
> 
> These patches allow to overwrite the hctosys RTC specified in the
> kernel config using CONFIG_RTC_HCTOSYS_DEVICE.
> 
> The background ist, that we have two almost identical x86 boards from
> MEN in Nuernberg. The first one buffers the CMOS RTC, the other one
> buffers an additional Epson RX8581 I2C RTC. We would like to use the
> same kernel, but the only parameter we could not overwrite when
> starting the kernel or system was the RTC used to initialize the
> system clock.

You might have a look at a year old thread with working patches which
does a bit more too:

https://lkml.org/lkml/2014/6/13/6

Regards,

Alexander Holler

