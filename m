Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbaHHM0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 08:26:48 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33975 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296AbaHHM0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 08:26:45 -0400
Message-ID: <53E4C1A5.7000400@gmail.com>
Date: Fri, 08 Aug 2014 17:55:09 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Matthias Brugger <matthias.bgg@gmail.com>, linux-kernel@vger.kernel.org
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, gregkh@linuxfoundation.org, jslaby@suse.cz,
        grant.likely@linaro.org, alan@linux.intel.com, heiko@sntech.de,
        yingjoe.chen@gmail.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v3 1/2] tty: serial: 8250: Add Mediatek UART driver
References: <1407497524-26535-1-git-send-email-matthias.bgg@gmail.com> <1407497524-26535-2-git-send-email-matthias.bgg@gmail.com>
In-Reply-To: <1407497524-26535-2-git-send-email-matthias.bgg@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 05:02 PM, Matthias Brugger wrote:
> This patch adds support for the UART block found on Mediatek SoCs.
> The device has a highspeed register which influences the calcualtion of the
> divisor. The chip lacks support for some baudrates. When requested, we set the
> divisor to the next smaller baudrate and adjust the c_cflag accordingly.

(...)

> +static struct platform_driver mtk8250_platform_driver = {
> +	.driver = {
> +		.name		= "mt6577-uart",
> +		.owner		= THIS_MODULE,

We can remove this field. Its updated by module_platform_driver()

Thanks.

-- 
Regards,
Varka Bhadram.

