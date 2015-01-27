Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbbA0J2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 04:28:36 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:55227 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077AbbA0J2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 04:28:34 -0500
Message-ID: <1422350909.14015.12.camel@x220>
Subject: Re: [PATCH] staging: Remove the Android logger driver
From: Paul Bolle <pebolle@tiscali.nl>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Rom Lemarchand <romlem@google.com>,
        Mark Salyzyn <salyzyn@google.com>, Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date: Tue, 27 Jan 2015 10:28:29 +0100
In-Reply-To: <1422302852-11499-1-git-send-email-john.stultz@linaro.org>
References: <20150125121139.GA30332@kroah.com>
	 <1422302852-11499-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2015 09:28:30.0142 (UTC) FILETIME=[9CB19DE0:01D03A13]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-26 at 12:07 -0800, John Stultz wrote:
> With the relase of Lollipop, Android no longer
> requires the logger driver.
> 
> There are three patches which the android dev's
> still need before they drop logger on all their
> devices:
> 
> [PATCH v4 1/5] pstores: use scnprintf
> [PATCH v2 2/5] pstore: remove superfluous memory size check
> [PATCH 3/5] pstore: handle zero-sized prz in series
> [PATCH v4 4/5] pstore: add pmsg
> [PATCH 5/5] pstore: selinux: add security in-core xattr support for pstore and debugfs
> 
> But these seem to have been acked and are hopefully
> queued for upstream.
> 
> So this patch removes the logger driver from staging.
> 
> Cc: Rom Lemarchand <romlem@google.com>,
> Cc: Mark Salyzyn <salyzyn@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/staging/android/Kconfig  |  17 -

Please include the change that would add
   drivers/staging/android/Makefile |   1 -

>  drivers/staging/android/logger.c | 807 ---------------------------------------
>  drivers/staging/android/logger.h |  89 -----
>  3 files changed, 913 deletions(-)
>  delete mode 100644 drivers/staging/android/logger.c
>  delete mode 100644 drivers/staging/android/logger.h

That is also delete this line:
    obj-$(CONFIG_ANDROID_LOGGER)           += logger.o

Thanks,


Paul Bolle

