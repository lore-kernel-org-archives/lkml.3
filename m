Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3AUPoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 10:44:11 -0500
Received: from service87.mimecast.com ([91.220.42.44]:42760 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3AUPoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 10:44:09 -0500
Message-ID: <1358783045.6590.26.camel@hornet>
Subject: Re: [PATCH] mfd: vexpress: export global functions to fix build
 error
From: Pawel Moll <pawel.moll@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jan 2013 15:44:05 +0000
In-Reply-To: <1357463779-28096-1-git-send-email-linux@roeck-us.net>
References: <1357463779-28096-1-git-send-email-linux@roeck-us.net>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 21 Jan 2013 15:44:05.0609 (UTC) FILETIME=[24D8FD90:01CDF7EE]
X-MC-Unique: 113012115440708301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-06 at 09:16 +0000, Guenter Roeck wrote:
> Compiling vexpress client drivers as module results in error messages such as
> 
> ERROR: "__vexpress_config_func_get" [drivers/hwmon/vexpress.ko] undefined!
> ERROR: "vexpress_config_func_put" [drivers/hwmon/vexpress.ko] undefined!
> 
> This is because the global functions in drivers/mfd/vexpress-config.c are not
> exported. Fix it.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Uh, right. Exported read/write but those are pretty much useless without
the other ones...

Thanks a lot, I'll get it queued with the other vexpress fixes and push
it upstream as soon as possible!

Pawel


