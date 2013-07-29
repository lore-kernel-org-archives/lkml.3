Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab3G2RFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:05:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48856 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3G2RFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:05:43 -0400
Message-ID: <51F6A0A9.5040702@infradead.org>
Date: Mon, 29 Jul 2013 10:04:41 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Jonathan Kim <jonathankim@gctsemi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dean ahn <deanahn@gctsemi.com>
Subject: Re: linux-next: Tree for Jul 29 (staging/gdm724x)
References: <20130729163906.7ba07f7c024ad364b2feb513@canb.auug.org.au>
In-Reply-To: <20130729163906.7ba07f7c024ad364b2feb513@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/13 23:39, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130726:
> 

on i386:
# CONFIG_TTY is not set


ERROR: "tty_port_tty_get" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "tty_port_close_end" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "tty_register_driver" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "tty_buffer_request_room" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "put_tty_driver" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "tty_port_close_start" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "tty_set_operations" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "tty_port_init" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "tty_insert_flip_string_fixed_flag" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "tty_register_device" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "tty_unregister_device" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "tty_std_termios" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "tty_unregister_driver" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "__tty_alloc_driver" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "tty_flip_buffer_push" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "tty_port_tty_set" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "tty_wakeup" [drivers/staging/gdm724x/gdmtty.ko] undefined!
ERROR: "tty_port_block_til_ready" [drivers/staging/gdm724x/gdmtty.ko] undefined!



-- 
~Randy
