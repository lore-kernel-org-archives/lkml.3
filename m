Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073Ab3IFJsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 05:48:16 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44225 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3IFJsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 05:48:14 -0400
Date: Fri, 6 Sep 2013 11:48:09 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3] kconfig: do not special-case 'MODULES' symbol
Message-ID: <20130906094809.GE3271@free.fr>
References: <1378242287-12759-1-git-send-email-yann.morin.1998@free.fr>
 <5228510C.1020906@suse.cz>
 <522856C9.3030106@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <522856C9.3030106@suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On 2013-09-05 12:02 +0200, Michal Marek spake thusly:
> On 5.9.2013 11:38, Michal Marek wrote:
> > On 3.9.2013 23:04, Yann E. MORIN wrote:
> >> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> >> This patch changes the way we enable/disable tristates: if a symbol was
> >> found with 'option modules' attached to it, then that symbol controls
> >> enabling tristates. Otherwise, tristates are disabled, even if a symbol
> >> named 'MODULES' exists.
> > 
> > Wasn't this change supposed to fix allmodconfig with KCONFIG_ALLCONFIG
> > (http://lkml.org/lkml/2013/8/8/573)? Or is there still more to do?
> > Because I'm still getting:
> > [...]
> > $ grep MODULES .config
> > CONFIG_MODULES_USE_ELF_RELA=y
> > # CONFIG_MODULES is not set
> > $
> 
> Otherwise, I have no problem merging this series.

Good, thanks!

> I'm just curious what
> to do with the allmodconfig with KCONFIG_ALLCONFIG bug.

Working on it! ;-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
