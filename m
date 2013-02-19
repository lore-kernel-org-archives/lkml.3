Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab3BSXkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 18:40:41 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47281 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab3BSXkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 18:40:39 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: kconfig-frontends-3.8.0.0 release
Date: Wed, 20 Feb 2013 00:40:35 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: Jan Engelhardt <jengelh@inai.de>, linux-kernel@vger.kernel.org
References: <201302192314.15995.yann.morin.1998@free.fr> <alpine.LNX.2.01.1302192328280.5517@nerf07.vanv.qr> <201302200021.31123.yann.morin.1998@free.fr>
In-Reply-To: <201302200021.31123.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302200040.35272.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan, All,

On Wednesday 20 February 2013 Yann E. MORIN wrote:
> $ ls -lrt /usr/bin/*{conf,gettext,diff}

Obviously, that line above should have been (with the same result):
$ ls -lrt /usr/bin/
lrwxrwxrwx 1 root root         26 Feb 19 23:11 fakeroot -> /etc/alternatives/fakeroot
lrwxrwxrwx 1 root root         24 Feb 19 23:11 rename -> /etc/alternatives/rename
lrwxrwxrwx 1 root root         21 Feb 19 23:11 c++ -> /etc/alternatives/c++
-rwxr-xr-x 1 root root      37440 Feb 19 23:13 kconfig-conf
-rwxr-xr-x 1 root root     135583 Feb 19 23:13 kconfig-mconf
-rwxr-xr-x 1 root root      95724 Feb 19 23:13 kconfig-nconf
-rwxr-xr-x 1 root root      18748 Feb 19 23:13 kconfig-gettext
-rwxr-xr-x 1 root root       3725 Feb 19 23:13 kconfig-tweak
-rwxr-xr-x 1 root root       3642 Feb 19 23:13 kconfig-diff
-rwxr-xr-x 1 root root       3378 Feb 19 23:13 kconfig-merge

I just tested in a new clean wheezy debootstrap, and it behaves as
expected, too. What is your distro, so I can try to reproduce it here?

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
