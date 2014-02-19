Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaBSASJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:18:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65271 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaBSASH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:18:07 -0500
MIME-Version: 1.0
In-Reply-To: <1392674322-9036-15-git-send-email-john.stultz@linaro.org>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
	<1392674322-9036-15-git-send-email-john.stultz@linaro.org>
Date: Tue, 18 Feb 2014 16:18:06 -0800
Message-ID: <CAMP5Xgfv6mnL8uh_iWCEL7WRtaMEYkE81ehNPtczF-pTAa-ebQ@mail.gmail.com>
Subject: Re: [PATCH 14/14] staging: binder: Improve Kconfig entry for ANDROID_BINDER_IPC_32BIT
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 1:58 PM, John Stultz <john.stultz@linaro.org> wrote:
> Add a more clear explanation of the option in the prompt, and
> make the config depend on ANDROID_BINDER_IPC being selected.
>
> Also sets the default to y, which matches AOSP.
>

I don't know if you want the default to be y. By the time this kernel
is used, the user-space default may have switched to using the 64 bit
interface by default. The android-3.10 kernel currently defaulting to
y since it may get used with a 4.4 android user-space, and because the
32 bit arm kernel is missing the 8 byte get_user variant that it
needs.

-- 
Arve Hjønnevåg
