Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab3LWNKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 08:10:31 -0500
Received: from monster.unsafe.ru ([195.18.34.9]:47449 "EHLO mail.unsafe.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211Ab3LWNKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 08:10:30 -0500
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Dec 2013 08:10:30 EST
Message-ID: <52B83457.8080907@gmail.com>
Date: Mon, 23 Dec 2013 17:02:15 +0400
From: Alexey Gladkov <gladkov.alexey@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, David Herrmann <dh.herrmann@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: VT Improvements
X-Enigmail-Version: 1.6
OpenPGP: id=4CFFD434;
	url=http://pgp.mit.edu:11371/pks/lookup?op=vindex&fingerprint=on&search=0xA45ABA544CFFD434
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings!

I would like to know about the VT plans. Historically, keymap
implementations are similar in the kernel and kbd project. I rewrote
it in kbd. So, it can handle keycodes bigger than 255. In a kernel
everything remained as before. I want to fix this part in a kernel. As
pluses will be:

* opportunity to define keycode > 255.
* opportunity to reduce this table a kernel in most cases.

I would like to ask your opinion about my plans because I heard about
the thought of moving this functionality to user space.

Whether it is worth starting so large-scale changes?

-- 
Rgrds, legion


