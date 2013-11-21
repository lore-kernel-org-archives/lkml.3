Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3KUFHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 00:07:48 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57304 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3KUFHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 00:07:46 -0500
Date: Wed, 20 Nov 2013 21:07:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, rydberg@euromail.se, floe@butterbrot.org,
        dh.herrmann@gmail.com, linux-input@vger.kernel.org
Subject: Re: randconfig build error with next-20131120, in
 drivers/input/touchscreen
Message-ID: <20131121050733.GD4702@core.coreip.homeip.net>
References: <CA+r1ZhimRvYuw2SAajEM6y-P2TL3KMdAMyX6UQ0BFb-peRMn5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+r1ZhimRvYuw2SAajEM6y-P2TL3KMdAMyX6UQ0BFb-peRMn5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim,

On Wed, Nov 20, 2013 at 11:23:31AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/built-in.o: In function `sur40_disconnect':
> sur40.c:(.text+0x15c1cc): undefined reference to
> `input_unregister_polled_device'
> sur40.c:(.text+0x15c1d5): undefined reference to `input_free_polled_device'
> drivers/built-in.o: In function `sur40_probe':
> sur40.c:(.text+0x15c47a): undefined reference to `input_allocate_polled_device'
> sur40.c:(.text+0x15c65b): undefined reference to `input_register_polled_device'
> sur40.c:(.text+0x15c68b): undefined reference to `input_free_polled_device'
> make: *** [vmlinux] Error 1

Thanks for the report. I amended the commit to select INPUT_POLLDEV.

-- 
Dmitry
