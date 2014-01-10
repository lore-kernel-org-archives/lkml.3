Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaAJEyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 23:54:17 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53684 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaAJEyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 23:54:13 -0500
Message-ID: <52CF7CF2.5070002@linaro.org>
Date: Thu, 09 Jan 2014 20:54:10 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Jesse Barker <jesse.barker@arm.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 0/2] ION dummy driver
References: <1389325255-31534-1-git-send-email-john.stultz@linaro.org> <20140110042357.GA4031@kroah.com>
In-Reply-To: <20140110042357.GA4031@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 08:23 PM, Greg KH wrote:
> On Thu, Jan 09, 2014 at 07:40:53PM -0800, John Stultz wrote:
>> Greg: I realize this is after the usual -rc6 cutoff for staging,
>> so no pressure if you want to defer this for 3.15, but I saw you've
>> picked up a few things recently, so I figured I'd send it out so
>> I'm not just sitting on it while we wait for LCA to finish.
> I would have merged it, but I just tried and got a ton of errors when
> building:
>
> ERROR: "ion_device_destroy" [drivers/staging/android/ion/ion_dummy_driver.ko] undefined!
> ERROR: "ion_heap_destroy" [drivers/staging/android/ion/ion_dummy_driver.ko] undefined!
> ERROR: "ion_device_add_heap" [drivers/staging/android/ion/ion_dummy_driver.ko] undefined!
> ERROR: "ion_heap_create" [drivers/staging/android/ion/ion_dummy_driver.ko] undefined!
> ERROR: "ion_device_create" [drivers/staging/android/ion/ion_dummy_driver.ko] undefined!
>
> So, I'll just drop these patches and forget you ever sent them to me :)

Gah. Modules bite me every time! Should have been a bool and not
tristate in the Kconfig.

Sorry! I appreciate the heads up and the build related amnesia.  :)

thanks
-john

