Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaF2BQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 21:16:35 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54981 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaF2BQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 21:16:33 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53AF68EE.5080103@roeck-us.net>
Date: Sat, 28 Jun 2014 18:16:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Luca Tettamanti <kronos.it@gmail.com>, Jean Delvare <jdelvare@suse.de>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/4] fs: asus_atk0110: Fix DEFINE_SIMPLE_ATTRIBUTE semicolon
 definition and use
References: <cover.1403999769.git.joe@perches.com> <530fc2e19919f12996227b27645be7e8f911a7ba.1403999769.git.joe@perches.com>
In-Reply-To: <530fc2e19919f12996227b27645be7e8f911a7ba.1403999769.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2014 05:20 PM, Joe Perches wrote:
> The DEFINE_SIMPLE_ATTRIBUTE macro should not end in a ;
> Fix the one use in the kernel tree that did not have a semicolon.
>
> Signed-off-by: Joe Perches <joe@perches.com>

For hwmon:

Acked-by: Guenter Roeck <linux@roeck-us.net>

