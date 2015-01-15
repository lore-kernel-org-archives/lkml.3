Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbbAOBaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:30:20 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:46522 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbbAOBaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:30:18 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org, linux-samsung-soc@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: (ina2xx) Add ina231 compatible string
References: <1421279852-27965-1-git-send-email-khilman@kernel.org>
	<20150115005642.GA31033@roeck-us.net>
Date: Wed, 14 Jan 2015 17:30:15 -0800
In-Reply-To: <20150115005642.GA31033@roeck-us.net> (Guenter Roeck's message of
	"Wed, 14 Jan 2015 16:56:42 -0800")
Message-ID: <7hppagq194.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> writes:

> On Wed, Jan 14, 2015 at 03:57:32PM -0800, Kevin Hilman wrote:
>> From: Kevin Hilman <khilman@linaro.org>
>> 
>> Add support for "ina231" as compatible string.
>> 
>> Tested with the Exynos5422-based odroid-xu3 board which has on-board
>> INA231 sensors.
>> 
>> Signed-off-by: Kevin Hilman <khilman@linaro.org>
>
> Hi Kevin,
>
> can you also update Documentation/hwmon/ina2xx and Documentation/hwmon/Kconfig ?
>

Sure... coming right up.

Kevin

