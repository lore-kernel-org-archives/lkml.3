Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797Ab3BYUxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 15:53:48 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49707 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759762Ab3BYUxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 15:53:45 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: jlec@gentoo.org
Subject: Re: [PATCH] Use config scripts to detect ncurses libs for, menuconfig/nconfig dialogs
Date: Mon, 25 Feb 2013 21:53:39 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
References: <512A36BB.9070309@gentoo.org> <201302251930.22293.yann.morin.1998@free.fr> <512BCA76.6080601@gentoo.org>
In-Reply-To: <512BCA76.6080601@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302252153.39465.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin, All,

On Monday 25 February 2013 Justin wrote:
> On 25.02.2013 19:30, Yann E. MORIN wrote:
> > On Sunday 24 February 2013 Justin wrote:
> >> when ncurses is build with --with-termlib several symbols are moved to a
> >> seperate terminfo library (libtinfo.so). Current Kernel buildsystem
> >> results in a build error with menuconfig and nconfig dialogs.
> > 
> > Do you know of a distribution where this is the case, so I can test?
> 
> This is using Gentoo Linux testing with ld.gold. But I assume you will
> get the same result using any distro with gold.

No, I meant a distro where ncurses is built with --with-termlib.
On my Debian stable (squeeze), libtinfo does not exist at all,
so I can not test linking against it:

    $ apt-file search libtinfo
    (zilch)

But I'll see at installing a Gentoo (if that's not too complex) in a
VM to do the checks (can you confirm that Gentoo by default configures
ncurses with --with-termlib ?).

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
