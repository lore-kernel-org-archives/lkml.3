Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3AVSQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:16:20 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51072 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab3AVSQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:16:19 -0500
Message-ID: <50FED76B.10801@ti.com>
Date: Tue, 22 Jan 2013 12:16:11 -0600
From: Rob Clark <rob@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH 15/15] staging/omapdrm: don't build on multiplatform
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <50FEC508.50004@ti.com> <20130122173013.GA17212@kroah.com> <201301221747.24618.arnd@arndb.de>
In-Reply-To: <201301221747.24618.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 11:47 AM, Arnd Bergmann wrote:
> On Tuesday 22 January 2013, Greg Kroah-Hartman wrote:
>>> Ie. I'd prefer to re-enable omapdss on multi-plat rather than
>>> disabling omapdrm.  With changes in drm core, it is a bit of a pain
>>> to compile test all the arm drivers by doing N different builds, so
>>> we've been trying to get to the point of all arm drm drivers
>>> supporting multi-plat
>> Ok, I'll let you and Arnd fight it out and drop this patch from my
>> to-apply queue for now...
> If Rob thinks there is no danger in allowing omap2_dss to be built
> on all platforms, and Tomi has no objections, I'm fine with that, too.
> In general, that is the right solution, I was just trying to be
> conservative for the 3.8 cycle.

I think it should be safe.. or at least it built fine for multi-plat in 
the recent past and shouldn't really do anything if there is no omapdss 
platform device.

Do you want me to make a patch or are you already doing this?

BR,
-R

> 	Arnd

