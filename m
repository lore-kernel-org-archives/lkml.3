Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3AVRrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:47:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53833 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab3AVRra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:47:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 15/15] staging/omapdrm: don't build on multiplatform
Date: Tue, 22 Jan 2013 17:47:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Clark <rob@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <50FEC508.50004@ti.com> <20130122173013.GA17212@kroah.com>
In-Reply-To: <20130122173013.GA17212@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221747.24618.arnd@arndb.de>
X-Provags-ID: V02:K0:bmLjG2+iT7VtOYkdtDE/AOP/6zj/VFrW3rllSdXczTO
 BLgnJO3VMy0z9ODoLXwkuNRIkdHVsTGrM3wCHJKqbndDXT4rUB
 MVyBmKDCbW1G70cJuZ+V3uMswQtcmz+YFZwplZqhKdkWyTXAKU
 YBlMag4VClWiQcw05AbB5hrCKAlmKZYz9YrbQV4YUH7bTMnR+5
 Rj2ceZsb1Qvw88TPmmTu5mdAXp1B9VWhkoeDbbkA6bbZYnHhUq
 0LqutC9lB3qoEAHda9MoM2q3k2/pyPHvkHFzcwChnRHNcD45W/
 zB1WZHpZF7MUZcWDQ+SkR1XNZcANr0XKsy6xAIu78zEV6XP670
 6eEq/ioHEbjsCCDxRu3c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Greg Kroah-Hartman wrote:
> > Ie. I'd prefer to re-enable omapdss on multi-plat rather than
> > disabling omapdrm.  With changes in drm core, it is a bit of a pain
> > to compile test all the arm drivers by doing N different builds, so
> > we've been trying to get to the point of all arm drm drivers
> > supporting multi-plat
> 
> Ok, I'll let you and Arnd fight it out and drop this patch from my
> to-apply queue for now...

If Rob thinks there is no danger in allowing omap2_dss to be built
on all platforms, and Tomi has no objections, I'm fine with that, too.
In general, that is the right solution, I was just trying to be
conservative for the 3.8 cycle.

	Arnd
