Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598Ab3B1Vff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:35:35 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39725 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab3B1Vfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:35:32 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: justin <jlec@gentoo.org>
Subject: Re: [PATCH 1/2] Use config scripts to detect ncurses libs for menuconfig
Date: Thu, 28 Feb 2013 22:35:27 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
References: <jlec@gentoo.org> <201302281908.14787.yann.morin.1998@free.fr> <512FCCBA.7000404@gentoo.org>
In-Reply-To: <512FCCBA.7000404@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302282235.28016.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin, All,

On Thursday 28 February 2013 justin wrote:
> On 2/28/13 7:08 PM, Yann E. MORIN wrote:
> > Well, RHEL4 is still widely used, and it was released in 2005, so will
> > not have ncurses-5.6 (updates may have it, but not everybody installs
> > updates).
> 
> question, will such system be updated then to latest kernel sources? And
> if so, can't we require that for the ncurses based config menus need
> newer ncurses?

It's not that those systems will be updated to run the latest kernel, but
rather that those systems can be used to build a newer kernel for another
system (think eg. cross-compilation and embedded).

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
