Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3AUPUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 10:20:05 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44190 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab3AUPUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 10:20:04 -0500
Message-ID: <1358781598.6590.4.camel@hornet>
Subject: Re: [PATCH 2/2] hwmon: (vexpress) Fix build error seen if
 CONFIG_OF_DEVICE is not set
From: Pawel Moll <pawel.moll@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors <lm-sensors@lm-sensors.org>, Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jan 2013 15:19:58 +0000
In-Reply-To: <1356941588-25249-2-git-send-email-linux@roeck-us.net>
References: <1356941588-25249-1-git-send-email-linux@roeck-us.net>
	 <1356941588-25249-2-git-send-email-linux@roeck-us.net>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 21 Jan 2013 15:19:58.0446 (UTC) FILETIME=[C64570E0:01CDF7EA]
X-MC-Unique: 113012115200203601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-31 at 08:13 +0000, Guenter Roeck wrote:
> Fix:
> vexpress.c: In function ‘vexpress_hwmon_name_show’:
> vexpress.c:34:2: error: implicit declaration of function
> ‘of_get_property’ [-Werror=implicit-function-declaration]
> vexpress.c:34:27: warning: initialization makes pointer from integer
> without a cast [enabled by default]
> vexpress.c: In function ‘vexpress_hwmon_label_show’:
> vexpress.c:43:22: warning: initialization makes pointer from integer
> without a cast [enabled by default]
> 
> Seen if CONFIG_OF_DEVICE is not defined. of_get_property is declared in
> of.h which is only included by of_device.h if CONFIG_OF_DEVICE is defined.
> of.h needs to be included directly.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Thanks, Guenter! (of course it's way too late for Acked-by: Pawel Moll
<pawel.moll@arm.com>)

Pawel



