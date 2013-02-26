Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977Ab3BZSfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:35:17 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35235 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756921Ab3BZSfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:35:15 -0500
Message-ID: <1361903714.2023.19.camel@joe-AO722>
Subject: Re: [PATCH v5 03/12] hwmon: (nct6775) Add support for temperature
 sensors
From: Joe Perches <joe@perches.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Date: Tue, 26 Feb 2013 10:35:14 -0800
In-Reply-To: <1361903020-18526-4-git-send-email-linux@roeck-us.net>
References: <1361903020-18526-1-git-send-email-linux@roeck-us.net>
	 <1361903020-18526-4-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-26 at 10:23 -0800, Guenter Roeck wrote:
> diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
[]
> +static const u16 NCT6779_REG_TEMP_CONFIG[11] = { 0x18, 0x152 };

Isn't 11 too magic a number?


