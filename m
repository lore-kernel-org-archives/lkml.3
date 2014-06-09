Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550AbaFIOpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:45:41 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58279 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932628AbaFIOpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:45:38 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5395C88C.5070408@roeck-us.net>
Date: Mon, 09 Jun 2014 07:45:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@gmail.com>, Jean Delvare <jdelvare@suse.de>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hwmon: (ina2xx) Cast to s16 on shunt and current regs
References: <1402261584-5301-1-git-send-email-fabio.baltieri@gmail.com>
In-Reply-To: <1402261584-5301-1-git-send-email-fabio.baltieri@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2014 02:06 PM, Fabio Baltieri wrote:
> All devices supported by ina2xx are bidirectional and reports the
> measured shunt voltage and power values as a signed 16 bit, but the
> current driver implementation caches all registers as u16, leading to an
> incorrect sign extension when reporting to the userspace in
> ina2xx_get_value().
>
> This patch fixes the problem by casting the signed registers to s16.
> Tested on an INA219.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>

Applied.

Thanks,
Guenter

