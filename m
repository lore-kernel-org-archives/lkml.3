Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaE0S7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:59:12 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:63540 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaE0S7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:59:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140527185238.GA2115@kroah.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
	<20140527185238.GA2115@kroah.com>
Date: Tue, 27 May 2014 11:59:08 -0700
Message-ID: <CALAqxLUcyPzrSWnuygayw-b8OoSJ03zwGdZ1jPqa2g99oRaF_Q@mail.gmail.com>
Subject: Re: [PATCH 1/9] staging: ion: tidy up a bit
From: John Stultz <john.stultz@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heesub Shin <heesub.shin@samsung.com>, devel@driverdev.osuosl.org,
        Sunghwan Yun <sunghwan.yun@samsung.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 11:52 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, May 26, 2014 at 07:04:53PM +0900, Heesub Shin wrote:
>> For aesthetics and readability, rename goto labels, remove
>> useless code lines, and clarify function return type.
>>
>> Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
>> ---
>>  drivers/staging/android/ion/ion_page_pool.c   |  2 +-
>>  drivers/staging/android/ion/ion_priv.h        |  2 +-
>>  drivers/staging/android/ion/ion_system_heap.c | 57 ++++++++++++---------------
>>  3 files changed, 28 insertions(+), 33 deletions(-)
>
> For this whole series, I need someone from the Android team, or John, to
> ack them, as I have no way of testing.

Having Colin's ack would be best, but I can do some basic testing when
v2 is sent out.

thanks
-john
