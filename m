Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbaELNL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:11:56 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50974 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaELNLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:11:55 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5370C891.3070502@roeck-us.net>
Date: Mon, 12 May 2014 06:11:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Josef Gajdusek <atx@atx.name>, jdelvare@suse.de
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/hwmon/emc1403.c: add new revision numbers to
 emc1403_detect()
References: <20140512114826.GA16252@dashie>
In-Reply-To: <20140512114826.GA16252@dashie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 04:48 AM, Josef Gajdusek wrote:
> Adds new chip revision numbers to emc1403.c. Altough the datasheet (for emc1412) does not say so directly, it seems to suggest, that chips with revision ID 0x03 exist.
>

In Table 10.1:

Rev. 1.37 (12-23-09) Section 7.17, "Revision Register"

Changed default from 01h to 03h to match the actual value.

Rev. 1.38 changed it to 0x04.

> Signed-off-by: Josef Gajdusek <atx@atx.name>

Thanks, will apply.

Guenter

