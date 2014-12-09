Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbaLIEGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 23:06:13 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:62877 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbaLIEGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 23:06:12 -0500
MIME-Version: 1.0
In-Reply-To: <20141208120058.GI3951@x1>
References: <20141208120058.GI3951@x1>
Date: Mon, 8 Dec 2014 20:06:11 -0800
X-Google-Sender-Auth: -6ix_dkz5VkdrMYlDmZBCfTqqwM
Message-ID: <CA+55aFzHz-a3tAc9PWVs1h_50EYFi=NM10+KmwP=Rw_xqx1_oA@mail.gmail.com>
Subject: Re: [GIT PULL] MFD for v3.19
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Johan Hovold <johan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 4:00 AM, Lee Jones <lee.jones@linaro.org> wrote:
>
> Johan Hovold (4):
>       mfd: Use mfd_add_hotplug_devices() helper

This clashed with the earlier fix "mfd: viperboard: Fix
platform-device id collision" also by Johan.

My merge resolution ends up taking the mfd_add_hotplug_devices() version.

See drivers/mfd/viperboard.c, and somebody should double-check and
test that this actually works. The "Fix platform-device id collision"
commit supposedly fixed a problem with multiple boards, I'm
hoping/assuming that the mfd_add_hotplug_devices() helper handles that
case correctly.

                     Linus
