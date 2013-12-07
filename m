Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab3LGQCy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 11:02:54 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40039 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab3LGQCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 11:02:52 -0500
Date: Sat, 7 Dec 2013 08:02:46 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Moiseev <o2g.org.ru@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hotplug@vger.kernel.org
Subject: Re: synaptics: PS/2 touchpad isn't detected if a keyboard key is
 held down on boot
Message-ID: <20131207160246.GA11635@core.coreip.homeip.net>
References: <CABWXVkMdyDNxG3QFOvyx4=6EiJQ5ik9aJxa7jQvtO+UJKwc8Fw@mail.gmail.com>
 <CABWXVkMUFdRKNm76Vc3oJ+Ef9M_MS1xU2TKh=rdyv-t9Cq5V1w@mail.gmail.com>
 <CABWXVkNXzxrZJiYshhsWFRf4fDgUL3=tmFtv23w=sZtZM7Rxgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABWXVkNXzxrZJiYshhsWFRf4fDgUL3=tmFtv23w=sZtZM7Rxgg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 05:47:09PM +0400, Andrey Moiseev wrote:
> I inserted a printk into ps2_handle_response(struct ps2dev *ps2dev,
> unsigned char data) in "drivers/input/serio/libps2.c" and other
> functions in the file.
> It really eats scancodes from the keyboard, as I see (0x23 is the 'H'
> press scancode). Seems like the scancodes are mixed with reasonable
> values. Is it a bug in the controller? 

Not necessarily... Can you boot with i8042.debug=1 and post full dmesg?

Thanks.

-- 
Dmitry
