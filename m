Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab3IAA66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 20:58:58 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55351 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3IAA65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 20:58:57 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sat, 31 Aug 2013 19:58:57 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52229150.4090009@roeck-us.net>
Date: Sat, 31 Aug 2013 17:58:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Schmidtke <sjakub@gmail.com>
Subject: Re: [PATCH] staging: asus_oled: Create device attributes automatically
References: <1377987876-2837-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1377987876-2837-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2013 03:24 PM, Guenter Roeck wrote:
> The 'enable' and 'picture' attributes are created for all oled_class devices.
> They can be created automatically when creating the oled_class device.
> This simplifies the code and ensures that the attributes exist when the
> udev event announcing device registration is generated.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Just noticed that the driver is gone from -next.
Oh well. Sorry for the noise.

Guenter


