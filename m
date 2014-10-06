Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaJFSjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:39:20 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:49124 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaJFSjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:39:19 -0400
MIME-Version: 1.0
In-Reply-To: <1412620095-593-1-git-send-email-geert@linux-m68k.org>
References: <1412620095-593-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 6 Oct 2014 20:39:17 +0200
X-Google-Sender-Auth: zO9bJDwpqe6q18szj5LxBhyWDmY
Message-ID: <CAMuHMdWCTfJWWdeHSh3jOJx+9CCGfsONrR6X4vew4j5cULUpzg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.17
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 6, 2014 at 8:28 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.17[1]  to v3.17-rc7[3], the summaries are:
>   - build errors: +12/-6

  + /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error:
implicit declaration of function 'i2c_check_functionality'
[-Werror=implicit-function-declaration]:  => 117:2
  + /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error:
implicit declaration of function 'i2c_master_send'
[-Werror=implicit-function-declaration]:  => 96:2
  + /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error:
implicit declaration of function 'i2c_smbus_read_byte_data'
[-Werror=implicit-function-declaration]:  => 28:2
  + /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error:
implicit declaration of function 'i2c_smbus_read_word_data'
[-Werror=implicit-function-declaration]:  => 64:2
  + /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error:
implicit declaration of function 'i2c_smbus_write_byte_data'
[-Werror=implicit-function-declaration]:  => 46:2
  + /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error:
implicit declaration of function 'i2c_smbus_write_word_data'
[-Werror=implicit-function-declaration]:  => 82:2
  + /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error:
implicit declaration of function 'i2c_transfer'
[-Werror=implicit-function-declaration]:  => 130:2
  + /scratch/kisskb/src/drivers/extcon/extcon-sm5502.c: error:
implicit declaration of function 'i2c_add_driver'
[-Werror=implicit-function-declaration]:  => 718:2

x86_64-randconfig

Fix available, even promised by the maintainer to be in 3.17-rc2:

https://lkml.org/lkml/2014/8/20/874

> [1] http://kisskb.ellerman.id.au/kisskb/head/7938/ (118 out of 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7921/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
