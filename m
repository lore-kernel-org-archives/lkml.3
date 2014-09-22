Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaIVN15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:27:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59770 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753988AbaIVN1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:27:55 -0400
Date: Mon, 22 Sep 2014 14:27:43 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Herring <robh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus <magnus.damm@gmail.com>, Simon <horms@verge.net.au>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH][resend] of: Add vendor 2nd prefix for Asahi Kasei Corp
Message-ID: <20140922132743.GM3290@leverpostej>
References: <20140611165410.GK5099@sirena.org.uk>
 <CAMuHMdUT0hEBGbN+W-Oz5zJ0N8S2VDMndqtDO=EtWF3jG2MEew@mail.gmail.com>
 <20140611170233.GL5099@sirena.org.uk>
 <5398A53D.3020706@wwwdotorg.org>
 <20140611190444.GN5099@sirena.org.uk>
 <5398AB07.4040304@wwwdotorg.org>
 <87sinbdk44.wl%kuninori.morimoto.gx@renesas.com>
 <878ulzx6hr.wl%kuninori.morimoto.gx@gmail.com>
 <20140922130026.GK3290@leverpostej>
 <CAMuHMdX22z97SbGS1HDiYfJ1PXxyEN2S8D7w4sr+4bUwD+mJZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdX22z97SbGS1HDiYfJ1PXxyEN2S8D7w4sr+4bUwD+mJZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 02:24:24PM +0100, Geert Uytterhoeven wrote:
> Hi Mark,

Hi Geert,

> On Mon, Sep 22, 2014 at 3:00 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> > Given all that, I think we should get rid of the "ak" prefix entirely,
> > fix up the seaboard dts, and leave the legacy matching for "ak,ak8975"
> > up to the i2c framework. However, that would imply deleting from
> > vendor-prefixes.txt (if we want people to be warned on use of "ak"), and
> > that's not a good precedent to set.
> 
> Instead of deleting, we can deprecate, like was done for powervr:
> 
> powervr PowerVR (deprecated, use img)

Ah. I tried to see if we had any deprecated bindings, but I somehow
failed to search correctly and missed powervr.

> Still missing is an update for checkpatch to warn when a deprecated
> vendor prefix is used.

Marking it deprecated and warning with checkpatch is certainly
preferable.

Mark.
