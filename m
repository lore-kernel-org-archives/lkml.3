Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaKJSKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:10:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaKJSKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:10:50 -0500
Date: Tue, 11 Nov 2014 03:09:29 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, peter@hurleysoftware.com
Subject: Re: randconfig build error with next-20141110, in drivers/tty/vt/vt.c
Message-ID: <20141110180929.GA13084@kroah.com>
References: <CA+r1ZhjfVNHOL_ZON2bpt9y6CB0J5rtrNhuV0XNRWqc2hGA57Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+r1ZhjfVNHOL_ZON2bpt9y6CB0J5rtrNhuV0XNRWqc2hGA57Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 09:13:25AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/tty/vt/vt.c: In function ‘tioclinux’:
> drivers/tty/vt/vt.c:2703:4: error: implicit declaration of function
> ‘vt_get_kmsg_redirect’ [-Werror=implicit-function-declaration]
>     data = vt_get_kmsg_redirect();
>     ^
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/tty/vt/vt.o] Error 1

This is due to a patch from Peter Hurley, but I can't work out what to
do to fix it...

Peter?

