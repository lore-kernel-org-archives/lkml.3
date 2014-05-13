Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaEMBCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 21:02:37 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51311 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaEMBCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 21:02:36 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53716F23.4010704@roeck-us.net>
Date: Mon, 12 May 2014 18:02:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Josef Gajdusek <atx@atx.name>
CC: jdelvare@suse.de, lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] hwmon: (emc1403) Various enhancements
References: <1399921311-9524-1-git-send-email-linux@roeck-us.net> <20140512210801.GA7839@dashie>
In-Reply-To: <20140512210801.GA7839@dashie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 02:08 PM, Josef Gajdusek wrote:
> Had to fix wrong variable being printed in show_bit(). After that, everything on the 1412 seems to work fine including alarms.
>
> -	return sprintf(buf, "%d\n", !!(retval & sda->index));
> +	return sprintf(buf, "%d\n", !!(val & sda->index));
>
>

Hi Josef,

Fixed with v2. Thanks a lot for the feedback!

Guenter


