Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaBRTIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:08:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaBRTII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:08:08 -0500
Date: Tue, 18 Feb 2014 11:09:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 13/14] staging: binder: Support concurrent 32 bit and 64
 bit processes.
Message-ID: <20140218190933.GB10376@kroah.com>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
 <1392674322-9036-14-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392674322-9036-14-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 01:58:41PM -0800, John Stultz wrote:
> From: Arve Hjønnevåg <arve@android.com>
> 
> Add binder_size_t and binder_uintptr_t that is used instead of size_t and
> void __user * in the user-space interface.
> 
> Use 64 bit pointers on all systems unless CONFIG_ANDROID_BINDER_IPC_32BIT
> is set (which enables the old protocol on 32 bit systems).
> 
> Change BINDER_CURRENT_PROTOCOL_VERSION to 8 if
> CONFIG_ANDROID_BINDER_IPC_32BIT is not set.
> 
> Add compat ioctl.
> 
> Cc: Colin Cross <ccross@android.com>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Android Kernel Team <kernel-team@android.com>
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> [jstultz: Merged with upstream type changes. Tweaked commit message.
> Various whitespace fixes and longer Kconfig description for checkpatch]
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Same as the previous patch, I'm not going to take this until the Android
team says it's ok, and given the borked-ness of the previous patch, I'm
doubting that's going to happen...

So consider these 3 patches dropped, feel free to resend them when fixed
up and acked.

thanks,

greg k-h
