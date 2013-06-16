Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab3FPJdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 05:33:11 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38413 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab3FPJdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 05:33:09 -0400
Date: Sun, 16 Jun 2013 11:33:04 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Benjamin Poirier <bpoirier@suse.de>, Wang YanQing <udknight@gmail.com>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH kbuild-next] kconfig/lxdialog: Add definitions for
 mininimum (re)size values
Message-ID: <20130616093304.GB3495@free.fr>
References: <1371287255-4172-1-git-send-email-sedat.dilek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1371287255-4172-1-git-send-email-sedat.dilek@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat, All,

On 2013-06-15 11:07 +0200, Sedat Dilek spake thusly:
> Commit c8dc68ad0fbd ("kconfig/lxdialog: support resize") added support
> for resizing, but forgot to collect all hardcoded values at one single
> place.
> 
> Also add a definition for the check for a minimum screen/window size
> of 80x19.
> 
> [ ChangeLog v3:
>   * Rename MENU_{HEIGTH,WIDTH}_MIN -> MENUBOX_{HEIGTH,WIDTH}_MIN
>   ChangeLog v2:
>   * Rename WIN_{HEIGTH,WIDTH}_MIN -> WINDOW_{HEIGTH,WIDTH}_MIN
>   * Mention the check for a minimum screen/window size in the changelog
>   * Add a comment above the block of new definitions ]
> 
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>

I've taken this in my tree, and will push to Michal for the next merge
window:
    https://www.gitorious.org/linux-kconfig/linux-kconfig/ yem-kconfig-for-next

Thank you!

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
