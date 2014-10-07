Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbaJGXgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:36:45 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:41261 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbaJGXgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:36:41 -0400
MIME-Version: 1.0
In-Reply-To: <1412659726-29957-9-git-send-email-linux@roeck-us.net>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
	<1412659726-29957-9-git-send-email-linux@roeck-us.net>
Date: Wed, 8 Oct 2014 03:36:41 +0400
Message-ID: <CAMo8BfLX_0-+dqXeGK=rCdopLp1xi=uLyQF0ZMzU4bqKuFumYg@mail.gmail.com>
Subject: Re: [PATCH 08/44] kernel: Move pm_power_off to common code
From: Max Filippov <jcmvbkbc@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        linux-pm@vger.kernel.org, Chris Zankel <chris@zankel.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 9:28 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> pm_power_off is defined for all architectures. Move it to common code.

For xtensa:
Acked-by: Max Filippov <jcmvbkbc@gmail.com>

> Have all architectures call do_kernel_poweroff instead of pm_power_off.
> Some architectures point pm_power_off to machine_power_off. For those,
> call do_kernel_poweroff from machine_power_off instead.

-- 
Thanks.
-- Max
