Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaIIH0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:26:11 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:52769 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbaIIH0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:26:10 -0400
Date: Tue, 9 Sep 2014 11:29:11 +0300
From: Matti Vaittinen <matti.vaittinen@nsn.com>
To: ext Jason Cooper <jason@lakedaemon.net>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        "linux@roeck-us.net" <linux@roeck-us.net>, a.zummo@towertech.it,
        "jic23@kernel.org" <jic23@kernel.org>,
        "arno@natisbad.org" <arno@natisbad.org>,
        jgunthorpe@obsidianresearch.com, san@rosetechnology.dk, hs@denx.de,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Sverdlin Alexander <alexander.sverdlin@nsn.com>
Subject: Re: [RESEND PATCH v3]     rtc: ds1307: add trickle charger device
 tree binding
Message-ID: <20140909082902.GD21342@fi-ourus-dhcp00977.emea.nsn-net.net>
References: <20140908073216.GA20850@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140908112657.GD30828@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908112657.GD30828@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1814
X-purgate-ID: 151667::1410247499-00005326-E19921A9/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 07:26:57AM -0400, ext Jason Cooper wrote:
> Matti,
> 
> On Mon, Sep 08, 2014 at 10:32:24AM +0300, Matti Vaittinen wrote:
> > ---
> 
> Here.  Otherwise, it'll get included in the commit message, which I
> don't think was your intention.

Ok, thanks.

> 
> >  .../devicetree/bindings/i2c/trivial-devices.txt    |  1 -
> >  .../devicetree/bindings/rtc/dallas,ds1339.txt      | 18 ++++++
> >  drivers/rtc/rtc-ds1307.c                           | 66 ++++++++++++++++++++--
> >  3 files changed, 80 insertions(+), 5 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
> 
> I would split this into two patches, one for the binding documentation,
> and one for the C file changes.  You can then use
> ./scripts/get_maintainer.pl to see who the rtc maintainer is (nothing
> jumps out from my memory).

Splitting sounds reasonable. I will do this and also invert the default
diode setting to be connected as was suggested by Pavel in mail responce
to v1 of patch. And Alessandro is the maintainer for rtc according to
the MAINTAINERS file.

> 
> Most likely, the rtc maintainer will take the series with the DT
> maintainers Acks.  You made all the binding changes as discussed by Mark
> and I, so fwiw,
> 
> Acked-by: Jason Cooper <jason@lakedaemon.net>
> 
> Just keep in mind that I'm not a DT maintainer, I've just moved a lot of
> patches into that area :-P  When you respin the series to split it, just
> throw my Ack on the binding docs.

Thanks, although the doc will change when I invert the default diode
setting  =)

Br.
Matti

-- 
=============================================

Matti Vaittinen
Senile SW Specialist
FINLAND 

~~ When things go utterly wrong vim users can always type :help! ~~

