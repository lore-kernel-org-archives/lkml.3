Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3LGLBQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 06:01:16 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53525 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3LGLBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 06:01:08 -0500
MIME-Version: 1.0
In-Reply-To: <CABWXVkMdyDNxG3QFOvyx4=6EiJQ5ik9aJxa7jQvtO+UJKwc8Fw@mail.gmail.com>
References: <CABWXVkMdyDNxG3QFOvyx4=6EiJQ5ik9aJxa7jQvtO+UJKwc8Fw@mail.gmail.com>
Date: Sat, 7 Dec 2013 15:01:07 +0400
Message-ID: <CABWXVkMUFdRKNm76Vc3oJ+Ef9M_MS1xU2TKh=rdyv-t9Cq5V1w@mail.gmail.com>
Subject: Re: synaptics: PS/2 touchpad isn't detected if a keyboard key is held
 down on boot
From: Andrey Moiseev <o2g.org.ru@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

psmouse module is not loaded when I hold down a key on boot (when
GRUB2 says "loading vmlinuz"), and, in its turn, the PS/2 touchpad
doesn't work. Latest mainline kernel, latest stable one and probably
many older ones. I guess i8042's buffer gets full and that confuses
drivers somehow.

On Fri, Dec 6, 2013 at 9:22 PM, Andrey Moiseev <o2g.org.ru@gmail.com> wrote:
> This is an ancient bug, I noticed it since I bought my notebook.
> Synaptics PS/2 touchpad is not detected and is not shown in
> /dev/input/event* if I hold a keyboard key down when booting just
> started.
