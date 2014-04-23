Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaDWROq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:14:46 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46217 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750890AbaDWROp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:14:45 -0400
Date: Wed, 23 Apr 2014 18:13:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomasz Figa <t.figa@samsung.com>,
        open list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH RFC 3/3] drm/exynos: use pending_components for
	components tracking
Message-ID: <20140423171351.GH24070@n2100.arm.linux.org.uk>
References: <1397734130-21019-1-git-send-email-a.hajda@samsung.com> <1397734130-21019-4-git-send-email-a.hajda@samsung.com> <20140417220412.GZ24070@n2100.arm.linux.org.uk> <5351145D.8070207@samsung.com> <20140418124652.GE24070@n2100.arm.linux.org.uk> <535652B2.7000607@samsung.com> <20140422115145.GU24070@n2100.arm.linux.org.uk> <5357D68E.8060605@samsung.com> <20140423164328.GG24070@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423164328.GG24070@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 05:43:28PM +0100, Russell King - ARM Linux wrote:
> So, maybe you would like to finally address *my* point about TDA998x
> and your solution in a way that provides a satisfactory answer.  *Show*
> how it can be done, or *outline* how it can be done.

Let me be absolutely clear *why* I'm very interested in this - and that
is because I'm presently converting TDA998x and Armada DRM to use the
component helpers.  If your solution is better, then I'd want to convert
to that instead, and let's retire the component helpers.

At the moment, my belief is that your solution is *very* substandard and
suboptimal precisely for the reasons I've outlined, especially when it
comes to sharing a component between several drivers.

So, if you *really* care, you'll stop fobbing me off on this point and
provide some real technical input how you'd see your solution being used
in exactly the scenario that I've been outlining several times in this
thread.

For example, you could show what kind of modifications you expect would
be required to the _existing_ TDA998x driver to allow it to participate
as a device declared in DT as an entirely separate entity, probed via the
standard I2C probing methods, and then hook itself into the appropriate
DRM driver.  Remembering, of course, that the TDA998x device is used by
more than _just_ Armada DRM.

I don't care if you show it via pseudo-code or by real patch.  I just
want to know _how_ your solution could be used.  And I won't want some
silly remark like "trivially" or "I've already answered that."  I want
_you_ to _show_ _how_ it can be done.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
