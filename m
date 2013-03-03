Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3CCUNx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 15:13:53 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39816 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab3CCUNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 15:13:52 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] menuconfig: use config scripts to detect ncurses libs
Date: Sun, 3 Mar 2013 21:13:47 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: Michal Marek <mmarek@suse.cz>, jlec@gentoo.org,
        linux-kernel@vger.kernel.org
References: <jlec@gentoo.org> <201302281916.00257.yann.morin.1998@free.fr> <513095F6.2010000@suse.cz>
In-Reply-To: <513095F6.2010000@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303032113.47632.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On Friday 01 March 2013 Michal Marek wrote:
> On 28.2.2013 19:16, Yann E. MORIN wrote:
> > On Thursday 28 February 2013 jlec@gentoo.org wrote:
> >> This patch replaces the old heuristic for detection of ncurses libs for
> >> linking the ncurses menuconfig dialog by the use of the config scripts.
> >> This results in the requirement of ncurses version 5.6 or newer for menuconfig.
> > 
> > OTOH, RHEL4 is still a widely used distro, and was released in 2005,
> > so is using an ncurses older than 5.6, so I'm afraid we can't drop
> > the legacy code like that.
> 
> Yes, please keep support for older libraries if it does not require too
> much effort.

Yes, we want to keep support for old systems, indeed.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
