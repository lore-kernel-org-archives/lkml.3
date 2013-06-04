Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab3FDJdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:33:03 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:36843 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3FDJdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:33:01 -0400
MIME-Version: 1.0
In-Reply-To: <1370335914-31582-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1370335914-31582-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 4 Jun 2013 12:33:00 +0300
Message-ID: <CAHp75Vf26xsEGvfsSRoHcvdnep0Qp58LX7vgdT84r6YJLMONXA@mail.gmail.com>
Subject: Re: [PATCH] cris: kgdb: use native hex2bin
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Cris <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 11:51 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> There are kernel native helpers to convert hex ascii to the binary format:
> hex_to_bin() and hex2bin(). Thus, no need to reimplement them customly.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>

Forgot to mention this is v2.
Changes:
 - rebased against today's linux-next
 - v32 is also fixed
 - fixed missed usage of hex() outside of hex2mem()

--
With Best Regards,
Andy Shevchenko
