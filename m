Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaKUTxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:53:06 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:38347 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaKUTxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:53:05 -0500
MIME-Version: 1.0
In-Reply-To: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
References: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
Date: Fri, 21 Nov 2014 11:53:04 -0800
Message-ID: <CALAqxLVRJKHiZVr2_gW-uos-LtW5iQLs-qOWUedfWp70f9iHDw@mail.gmail.com>
Subject: Re: [PATCH 00/12]
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd.bergmann@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 11:44 AM, John Stultz <john.stultz@linaro.org> wrote:
> Hey Thomas, All,
>
> Just wanted to submit a handful of changes for 3.19
>
> * udelay_test/test_udelay consistent file naming
> * Time / ntp edge-case fixes from Xunlei
> * y2038-safe internal interfaces from Xunlei and me
> * Celanup suspend/resume timing y2038 issues
> * Remove y2038 unsafe inject_sleeptime inteface
>
> Just as an FYI, I'm trying out signing this tag with
> a new subkey on my yubikey. Hopefully haven't mucked
> it up.
