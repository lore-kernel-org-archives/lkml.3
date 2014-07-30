Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbaG3Ros (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:44:48 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:59662 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbaG3Roq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:44:46 -0400
MIME-Version: 1.0
In-Reply-To: <1404436946-28354-1-git-send-email-hyogi.gim@lge.com>
References: <1404436946-28354-1-git-send-email-hyogi.gim@lge.com>
Date: Wed, 30 Jul 2014 10:44:43 -0700
Message-ID: <CALAqxLVckQnDUBTS2JQJSwA7FFjH4dn5HtNB6ZOaj-U3-0EqOg@mail.gmail.com>
Subject: Re: [PATCH] drivers/rtc/interface.c: check the error after __rtc_read_time()
From: John Stultz <john.stultz@linaro.org>
To: Hyogi Gim <hyogi.gim@lge.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 6:22 PM, Hyogi Gim <hyogi.gim@lge.com> wrote:
> In __rtc_set_alarm(), the error after __rtc_read_time() is not checked.
> If rtc device fail to read time, we cannot guarantee the following process.
>
> Add the verification code for returned __rtc_read_time() error.
>
> Signed-off-by: Hyogi Gim <hyogi.gim@lge.com>

Thanks for sending this in. Sorry I didn't get to it earlier. I've got
it queued for testing and hopefully will make it for 3.17 (but I may
be cutting it close).

thanks
-john
