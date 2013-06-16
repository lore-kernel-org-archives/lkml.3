Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3FPEId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 00:08:33 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:61639 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3FPEIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 00:08:31 -0400
Date: Sun, 16 Jun 2013 12:07:58 +0800
From: Wang YanQing <udknight@gmail.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Benjamin Poirier <bpoirier@suse.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH kbuild-next] kconfig/lxdialog: Add definitions for
 mininimum (re)size values
Message-ID: <20130616040758.GA2022@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
	Benjamin Poirier <bpoirier@suse.de>,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1371287255-4172-1-git-send-email-sedat.dilek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371287255-4172-1-git-send-email-sedat.dilek@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 11:07:35AM +0200, Sedat Dilek wrote:
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
Acked-by: Wang YanQing <udknight@gmail.com>
