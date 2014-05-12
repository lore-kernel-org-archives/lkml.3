Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaELTzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:55:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbaELTzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:55:17 -0400
Date: Mon, 12 May 2014 21:55:13 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Josef Gajdusek <atx@atx.name>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/hwmon/emc1403.c: add support for emc14x2
Message-ID: <20140512215513.42076761@endymion.delvare>
In-Reply-To: <20140512184727.GA9003@roeck-us.net>
References: <20140512123409.GB16252@dashie>
	<20140512161415.GA16770@roeck-us.net>
	<20140512190327.4f65c90a@endymion.delvare>
	<20140512184727.GA9003@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 11:47:27 -0700, Guenter Roeck wrote:
> The chips are not only compatible, the even have the same device IDs.
> Maybe I missed it, but I did not find a difference.

The EMC141x seem to have fewer package options (no SOIC) but better
internal sensor accuracy (+/- 1°C instead of +/- 2°C.) The +/- 1°C
accuracy for the external channels is also guaranteed over a wider
temperature range. Just from a quick look at the product features,
there may be more.

-- 
Jean Delvare
SUSE L3 Support
