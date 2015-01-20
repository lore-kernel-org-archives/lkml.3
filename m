Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbbATTRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:17:42 -0500
Received: from smtp8.ore.mailhop.org ([54.148.153.48]:44016 "EHLO
	smtp8.ore.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbbATTRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:17:40 -0500
X-Greylist: delayed 2043 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2015 14:17:40 EST
X-Mail-Handler: DuoCircle Outbound SMTP
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@duocircle.com (see https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information for abuse reporting information)
X-MHO-User: U2FsdGVkX18P9GmgEIPYCHFAxEdeIird
Date: Tue, 20 Jan 2015 10:40:03 -0800
From: Tony Lindgren <tony@atomide.com>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Robinson <pbrobinson@gmail.com>
Subject: Re: linux-next: manual merge of the omap tree with the arm-soc tree
Message-ID: <20150120184002.GM7718@atomide.com>
References: <20150120110947.1a92a416@canb.auug.org.au>
 <20150120171048.GF7718@atomide.com>
 <CAOesGMjc+q5ZEFU4GugJT2RCSmhv48DAA8JzuCxf63eEO6tWVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMjc+q5ZEFU4GugJT2RCSmhv48DAA8JzuCxf63eEO6tWVQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Olof Johansson <olof@lixom.net> [150120 10:27]:
> On Tue, Jan 20, 2015 at 9:10 AM, Tony Lindgren <tony@atomide.com> wrote:
> > * Stephen Rothwell <sfr@canb.auug.org.au> [150119 16:12]:
> >> Hi Tony,
> >>
> >> Today's linux-next merge of the omap tree got a conflict in
> >> arch/arm/boot/dts/Makefile between commit cb612390e546 ("ARM: dts: Only
> >> build dtb if associated Arch and/or SoC is enabled") from the arm-soc
> >> tree and commit ac7452cee743 ("ARM: dts: Add minimal support for
> >> dm8168-evm") from the omap tree.
> >>
> >> I fixed it up (see below) and can carry the fix as necessary (no action
> >> is required).
> >
> > Uhh why is cb612390e546 doing formatting changes all over the place?
> > That's a sure way to produce merge conflicts..
> 
> It's intentional but a but annoying, yes -- we're resolving them as we
> merge in new DT contents so it won't be exposed outside of our tree
> (and -next, unfortunately).

OK. I don't have anything against cleaning up and sorting things to
avoid merge conflicts naturally :)

Maybe for other similar changes you can set up an immutable branch
abainst v3.xx-rc1 with just the clean-up that people can use as
a base without having to bring in all the other changes?

Regards,

Tony
