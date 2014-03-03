Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaCCH2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:28:35 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:47471 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbaCCH2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:28:32 -0500
MIME-Version: 1.0
In-Reply-To: <294021ae4578d627ac56704dab7caee5bca2db86.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
	<294021ae4578d627ac56704dab7caee5bca2db86.1393493277.git.rashika.kheria@gmail.com>
Date: Mon, 3 Mar 2014 15:28:31 +0800
Message-ID: <CALAqxLWRS9eS4dQCd0zNv7E=LJe_JK4GdyTyEB681OaJqb3jfw@mail.gmail.com>
Subject: Re: [PATCH 22/46] kernel: Include appropriate header file in time/timekeeping_debug.c
From: John Stultz <john.stultz@linaro.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        josh@joshtriplett.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 7:55 PM, Rashika Kheria
<rashika.kheria@gmail.com> wrote:
> Include appropriate header file kernel/time/timekeeping_internal.h in
> kernel/time/timekeeping_debug.c because it has prototype declaration of
> function defined in kernel/time/timekeeping_debug.c.
>
> This eliminates the following warning in
> kernel/time/timekeeping_debug.c:
> kernel/time/timekeeping_debug.c:68:6: warning: no previous prototype for 'tk_debug_account_sleep_time' [-Wmissing-prototypes]
>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>


Thanks for sending this in.. I've queued this for 3.15.

thanks
-john
