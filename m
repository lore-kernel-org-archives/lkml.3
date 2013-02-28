Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966Ab3B1SIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 13:08:20 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42461 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab3B1SIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 13:08:19 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2] Use config scripts to detect ncurses libs for menuconfig
Date: Thu, 28 Feb 2013 19:08:14 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: justin <jlec@gentoo.org>, linux-kernel@vger.kernel.org
References: <jlec@gentoo.org> <201302271937.49565.yann.morin.1998@free.fr> <512F24CC.2090906@gentoo.org>
In-Reply-To: <512F24CC.2090906@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302281908.14787.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin, All,

On Thursday 28 February 2013 justin wrote:
> > On a side note: is the old code still useful, now we use the config
> > scripts? In other words: are there cases where a ncurses install would
> > not provide those scripts?
> > 
> > If the answer is 'no', then just trash the old code away.
> > 
> > I've just tested Debian Squeeze (stable for now), and Cygwin, and they
> > both do provide ncurses{,w}5-config.
> > 
> 
> I looked into the ncurses releases back to 5.0. The first release
> containing is version 5.6 released in 2006. So I would guess we can
> assume that every system will have it.

Well, RHEL4 is still widely used, and it was released in 2005, so will
not have ncurses-5.6 (updates may have it, but not everybody installs
updates).

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
