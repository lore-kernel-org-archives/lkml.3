Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaBEMq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 07:46:27 -0500
Received: from gloria.sntech.de ([95.129.55.99]:60195 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbaBEMq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 07:46:26 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: arm@kernel.org, Rob Herring <robherring2@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCH v4] of: add functions to count number of elements in a property
Date: Wed, 05 Feb 2014 13:45:36 +0100
Message-ID: <8812602.o5pus1vSFK@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140205120652.9B1A7C40A89@trevor.secretlab.ca>
References: <27256277.YJ687suYy5@phil> <13514940.URVnEJ4NF0@phil> <20140205120652.9B1A7C40A89@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 5. Februar 2014, 12:06:52 schrieb Grant Likely:
> On Tue, 04 Feb 2014 19:48:17 +0100, Heiko Stübner <heiko@sntech.de> wrote:
> > Hi Grant,
> > 
> > On Tuesday, 4. February 2014 17:30:34 Grant Likely wrote:
> > > On Sat, 18 Jan 2014 09:07:30 -0600, Rob Herring <robherring2@gmail.com>
> > 
> > wrote:
> > > > On Sat, Jan 18, 2014 at 6:02 AM, Heiko StÃ¼bner <heiko@sntech.de> 
wrote:
> > > > > The need to know the number of array elements in a property is
> > > > > a common pattern. To prevent duplication of open-coded
> > > > > implementations
> > > > > add a helper static function that also centralises strict sanity
> > > > > checking and DTB format details, as well as a set of wrapper
> > > > > functions
> > > > > for u8, u16, u32 and u64.
> > > > > 
> > > > > Suggested-by: Mark Rutland <mark.rutland@arm.com>
> > > > > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > > > > ---
> > > > 
> > > > Looks good. Do you plan to convert some users to use this?
> > > 
> > > I'll take that as an acked-by. Merged, thanks.
> > 
> > before you taking this patch, I was planning on simply sending this as
> > part of my rockchip-smp series - as I'm currently the only user of it :-)
> > .
> > 
> > This going through your tree is most likely the better way, but now I need
> > it to somehow make its way into arm-soc too ... I guess some sort of
> > stable branch arm-soc could pull?
> 
> Nah, I'll drop it from my tree. Add my acked-by and merge it via
> arm-soc.

As I said on IRC, now it seems like you can keep this patch in your tree :-)

If we're really going with reserved-memory like you suggested in the rockchip-
smp series it removes the need to count u32-elements in a property for me, as 
the reserved blocks move into individual subnodes.


Heiko

