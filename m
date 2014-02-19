Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaBSAas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:30:48 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:48415 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaBSAar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:30:47 -0500
Message-ID: <5303FB34.4080306@linaro.org>
Date: Tue, 18 Feb 2014 16:30:44 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 14/14] staging: binder: Improve Kconfig entry for ANDROID_BINDER_IPC_32BIT
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>	<1392674322-9036-15-git-send-email-john.stultz@linaro.org> <CAMP5Xgfv6mnL8uh_iWCEL7WRtaMEYkE81ehNPtczF-pTAa-ebQ@mail.gmail.com>
In-Reply-To: <CAMP5Xgfv6mnL8uh_iWCEL7WRtaMEYkE81ehNPtczF-pTAa-ebQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 04:18 PM, Arve Hjønnevåg wrote:
> On Mon, Feb 17, 2014 at 1:58 PM, John Stultz <john.stultz@linaro.org> wrote:
>> Add a more clear explanation of the option in the prompt, and
>> make the config depend on ANDROID_BINDER_IPC being selected.
>>
>> Also sets the default to y, which matches AOSP.
>>
> I don't know if you want the default to be y. By the time this kernel
> is used, the user-space default may have switched to using the 64 bit
> interface by default. The android-3.10 kernel currently defaulting to
> y since it may get used with a 4.4 android user-space, and because the
> 32 bit arm kernel is missing the 8 byte get_user variant that it
> needs.

My thought is that currently folks who might be using the upstream
kernel would experience less friction, as they are likely to be using
the current userspace. Once the new userspace with the 64bit aware
binder is commonly available, removing the "default y" makes sense.

But until then it seems having a new config that defaults to n and
breaks existing users might be viewed as "unfriendly" :)

Does that seem reasonable?

thanks
-john

