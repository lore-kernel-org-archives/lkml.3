Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3EMICK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:02:10 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:34135 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab3EMICI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:02:08 -0400
MIME-Version: 1.0
In-Reply-To: <1367809448-9437-1-git-send-email-chao.xie@marvell.com>
References: <1367809448-9437-1-git-send-email-chao.xie@marvell.com>
Date: Mon, 13 May 2013 16:02:07 +0800
Message-ID: <CADApbegCt=uGcQxdukq-svi201J+YeAX1M1vs-dKAD_AD9HFPw@mail.gmail.com>
Subject: Re: [PATCH V2 0/5] input: pxa27x-keypad: enhancement and device tree support
From: Chao Xie <xiechao.mail@gmail.com>
To: Chao Xie <chao.xie@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, dmitry
What is your idea about these patches?
Do i need add someone else to review them?

On Mon, May 6, 2013 at 11:04 AM, Chao Xie <chao.xie@marvell.com> wrote:
> The patches include 2 parts
> 1. use matrix_keypad for matrix keyes support
> 2. add device tree support for pxa27x-keypad
>
> V2->V1:
> Do not copy the members from pdata. For device tree support,
> directly allocate the pdata structure.
>
> Chao Xie (5):
>   input: pxa27x-keypad: use matrix_keymap for matrix keyes
>   arm: mmp: use matrix_keymap for aspenite
>   arm: mmp: use matrix_keymap for teton_bga
>   input: pxa27x-keypad: remove the unused members at platform data
>   input: pxa27x-keypad: add device tree support
>
>  .../devicetree/bindings/input/pxa27x-keypad.txt    |   60 +++++
>  arch/arm/mach-mmp/aspenite.c                       |   10 +-
>  arch/arm/mach-mmp/teton_bga.c                      |    8 +-
>  drivers/input/keyboard/Kconfig                     |    1 +
>  drivers/input/keyboard/pxa27x_keypad.c             |  266 ++++++++++++++++++--
>  include/linux/platform_data/keypad-pxa27x.h        |    3 +-
>  6 files changed, 325 insertions(+), 23 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/input/pxa27x-keypad.txt
>
> --
> 1.7.4.1
>
