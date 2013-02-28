Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413Ab3B1U72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:59:28 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:65227 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3B1U7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:59:25 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 2/2] kconfig: use config scripts to detect ncurses libs
Date: Thu, 28 Feb 2013 21:59:20 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: jlec@gentoo.org, linux-kernel@vger.kernel.org
References: <jlec@gentoo.org> <1362045557-9123-1-git-send-email-jlec@gentoo.org>
In-Reply-To: <1362045557-9123-1-git-send-email-jlec@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302282159.20338.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin, All,

On Thursday 28 February 2013 jlec@gentoo.org wrote:
> When building ncurses with --with-termlib several symbols get moved from
> libncurses.so to libtinfo.so. Thus when linking with libncurses.so, one
> additionally needs to link with libtinfo.so.
> 
> Ncurses provides a config script (ncurses5-config) to assist finding ncurses.
> This patch makes use of it to detect the necessary libs for linking of the
> ncurses nconfig dialog.

I've queued that one in my tree, now, in branch yem-kconfig-for-next:
    https://www.gitorious.org/linux-kconfig/linux-kconfig

Thank you! :-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
