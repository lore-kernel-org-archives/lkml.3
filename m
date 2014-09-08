Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaIHL11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:27:27 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:15806 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752640AbaIHL1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:27:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19/xxVHGza6OgKRngzyB4PBme/1r3YQ/KM=
X-DKIM: OpenDKIM Filter v2.0.1 titan D59B05DAF30
Date: Mon, 8 Sep 2014 07:26:57 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Matti Vaittinen <matti.vaittinen@nsn.com>
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
Message-ID: <20140908112657.GD30828@titan.lakedaemon.net>
References: <20140908073216.GA20850@fi-ourus-dhcp00977.emea.nsn-net.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908073216.GA20850@fi-ourus-dhcp00977.emea.nsn-net.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matti,

On Mon, Sep 08, 2014 at 10:32:24AM +0300, Matti Vaittinen wrote:

>From here:

> Hi dt bindings maintainers (and others interested in device-tree bindings),
> 
>    I would like to get this included in your tree. Do you think there is
>    still something I could improve/change in order to get this accepted?
>    Or do you think I should address this to someone else?
> 
> 
> 
> 
> 
> 
> 
> 
> 

To here should go below the '---'

> Some DS13XX devices have "trickle chargers". Introduce a device tree binding
> for specifying the trickle charger configuration for ds1339.
> 
> Signed-off-by: Matti Vaittinen <matti.vaittinen@nsn.com>
> ---

Here.  Otherwise, it'll get included in the commit message, which I
don't think was your intention.

>  .../devicetree/bindings/i2c/trivial-devices.txt    |  1 -
>  .../devicetree/bindings/rtc/dallas,ds1339.txt      | 18 ++++++
>  drivers/rtc/rtc-ds1307.c                           | 66 ++++++++++++++++++++--
>  3 files changed, 80 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/rtc/dallas,ds1339.txt

I would split this into two patches, one for the binding documentation,
and one for the C file changes.  You can then use
./scripts/get_maintainer.pl to see who the rtc maintainer is (nothing
jumps out from my memory).

Most likely, the rtc maintainer will take the series with the DT
maintainers Acks.  You made all the binding changes as discussed by Mark
and I, so fwiw,

Acked-by: Jason Cooper <jason@lakedaemon.net>

Just keep in mind that I'm not a DT maintainer, I've just moved a lot of
patches into that area :-P  When you respin the series to split it, just
throw my Ack on the binding docs.

thx,

Jason.
