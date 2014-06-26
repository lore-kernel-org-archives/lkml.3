Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbaFZNqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 09:46:22 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59195 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294AbaFZNqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 09:46:21 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53AC242B.3020903@roeck-us.net>
Date: Thu, 26 Jun 2014 06:46:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
CC: naveenkrishna.ch@gmail.com, cpgs@samsung.com, herbert@gondor.apana.org.au
Subject: Re: [PATCH] hwmon: ntc_thermistor: correct the information printed
 during probe
References: <1403787014-5858-1-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1403787014-5858-1-git-send-email-ch.naveen@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 05:50 AM, Naveen Krishna Chatradhi wrote:
> Currently, dev_info() at the end of the probe says
> "type:%s ". But, prints the pdev->name.
>
> This patch uses "pdev_id->name" which prints the thermistor type.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

Another good catch.

Applied, thanks.

Guenter

