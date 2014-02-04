Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaBDStJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:49:09 -0500
Received: from gloria.sntech.de ([95.129.55.99]:52815 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbaBDStG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:49:06 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Grant Likely <grant.likely@linaro.org>, arm@kernel.org
Cc: Rob Herring <robherring2@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCH v4] of: add functions to count number of elements in a property
Date: Tue, 04 Feb 2014 19:48:17 +0100
Message-ID: <13514940.URVnEJ4NF0@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140204173034.2D899C4050F@trevor.secretlab.ca>
References: <27256277.YJ687suYy5@phil> <CAL_JsqJord1OOjwcKk1jqF5o+XO3uw+Lc4ATtQacgwZWAoQq1g@mail.gmail.com> <20140204173034.2D899C4050F@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Tuesday, 4. February 2014 17:30:34 Grant Likely wrote:
> On Sat, 18 Jan 2014 09:07:30 -0600, Rob Herring <robherring2@gmail.com> 
wrote:
> > On Sat, Jan 18, 2014 at 6:02 AM, Heiko Stübner <heiko@sntech.de> wrote:
> > > The need to know the number of array elements in a property is
> > > a common pattern. To prevent duplication of open-coded implementations
> > > add a helper static function that also centralises strict sanity
> > > checking and DTB format details, as well as a set of wrapper functions
> > > for u8, u16, u32 and u64.
> > > 
> > > Suggested-by: Mark Rutland <mark.rutland@arm.com>
> > > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > > ---
> > 
> > Looks good. Do you plan to convert some users to use this?
> 
> I'll take that as an acked-by. Merged, thanks.

before you taking this patch, I was planning on simply sending this as part of 
my rockchip-smp series - as I'm currently the only user of it :-) .

This going through your tree is most likely the better way, but now I need it 
to somehow make its way into arm-soc too ... I guess some sort of stable 
branch arm-soc could pull?


Thanks
Heiko
