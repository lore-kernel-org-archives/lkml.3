Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaBYQ5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 11:57:19 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:43736 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaBYQ5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:57:18 -0500
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Feb 2014 11:57:18 EST
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:fd64:c99e:f704:9cf4:8492]
In-Reply-To: <20140225164921.GA4458@kroah.com>
References: <20140225170944.d322d9868871bc2f669b92e5@canb.auug.org.au>
	<20140225164921.GA4458@kroah.com>
Date: Tue, 25 Feb 2014 08:51:37 -0800
Message-ID: <CAOesGMiTZN3z441d3bOaCcF8Zsss4WZv6YkH9CJpZtTBGxadWw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the arm-soc tree
From: Olof Johansson <olof@lixom.net>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 8:49 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, Feb 25, 2014 at 05:09:44PM +1100, Stephen Rothwell wrote:
>> Hi Greg,
>>
>> Today's linux-next merge of the staging tree got a conflict in
>> arch/arm/boot/dts/imx53-qsb.dts between commit d5eb195f26fa ("ARM: dts:
>> i.MX53: move common QSB nodes to new file") from the arm-soc tree and
>> commit 17b5001b5143 ("imx-drm: convert to componentised device support")
>> from the staging tree.
>>
>> I fixed it up (see at bottom) and can carry the fix as necessary (no
>> action is required).  I also added the following fix up patch:
>
> I think it's right, but I really have no idea about any of these.  I'll
> defer to Russell to ensure they are correct.

We normally merge all dts changes through arm-soc to avoid these kind
of conflicts. Since your tree is a stable one there isn't much to do
about it, but I'd appreciate it if we just got those parts of the
patch series in the future to avoid these situations. We've been bit
by it before.


-Olof
