Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaAJEX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 23:23:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaAJEX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 23:23:57 -0500
Date: Thu, 9 Jan 2014 20:23:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Jesse Barker <jesse.barker@arm.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 0/2] ION dummy driver
Message-ID: <20140110042357.GA4031@kroah.com>
References: <1389325255-31534-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389325255-31534-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 07:40:53PM -0800, John Stultz wrote:
> Greg: I realize this is after the usual -rc6 cutoff for staging,
> so no pressure if you want to defer this for 3.15, but I saw you've
> picked up a few things recently, so I figured I'd send it out so
> I'm not just sitting on it while we wait for LCA to finish.

I would have merged it, but I just tried and got a ton of errors when
building:

ERROR: "ion_device_destroy" [drivers/staging/android/ion/ion_dummy_driver.ko] undefined!
ERROR: "ion_heap_destroy" [drivers/staging/android/ion/ion_dummy_driver.ko] undefined!
ERROR: "ion_device_add_heap" [drivers/staging/android/ion/ion_dummy_driver.ko] undefined!
ERROR: "ion_heap_create" [drivers/staging/android/ion/ion_dummy_driver.ko] undefined!
ERROR: "ion_device_create" [drivers/staging/android/ion/ion_dummy_driver.ko] undefined!

So, I'll just drop these patches and forget you ever sent them to me :)

greg k-h

p.s.  Feel free to resend them when they work.
