Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaBQQoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 11:44:13 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:59185 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaBQQoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 11:44:12 -0500
MIME-Version: 1.0
In-Reply-To: <20140205141917.GA25091@localhost>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
 <1391006064-28890-4-git-send-email-b.brezillon.dev@gmail.com>
 <20140129175331.GA27143@localhost> <20140205111500.B19FDC40A89@trevor.secretlab.ca>
 <52F23DF4.7010901@gmail.com> <20140205141917.GA25091@localhost>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 17 Feb 2014 16:43:51 +0000
X-Google-Sender-Auth: _PaE8oMnIwftRs22Tb2zBJo_0vg
Message-ID: <CACxGe6vW3m8DA3rGSane6GNmjXHt=pjAPVr25WZyopV9jA-XUw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 03/14] of: mtd: add documentation for
 nand-ecc-level property
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Boris BREZILLON <b.brezillon.dev@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pekon Gupta <pekon@ti.com>, Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 2:19 PM, Ezequiel Garcia
<ezequiel.garcia@free-electrons.com> wrote:
> Hi Grant, Boris:
>
> (BTW, dropped Russell, Rob Landley and some unrelated mailing lists from Cc,
> and added Thomas, Gregory and Rob Herring).
>
> On Wed, Feb 05, 2014 at 02:34:44PM +0100, Boris BREZILLON wrote:
>> On 05/02/2014 12:15, Grant Likely wrote:
>> > On Wed, 29 Jan 2014 14:53:32 -0300, Ezequiel Garcia <ezequiel.garcia@free-electrons.com> wrote:
> [..]
>> >>
>> >> Maybe we can discuss about it now?
>> >>
>> >>    nand-ecc-strength : integer ECC required strength.
>> >>    nand-ecc-size : integer step size associated to the ECC strength.
>> > I'm okay with either, but the above binding is indeed more readable.
>>
>> That's fine by me, if everybody agrees, let's go for the
>> nand-ecc-strength/nand-ecc-size couple then.
>>
>
> Great. So, if some DT dictator^C^Cmaintainers can Ack this binding,
> I can send a new patchset, with pxa3xx-nand using it...
>
>> I'll rebase next version of my series on Ezequiel's patch providing
>> these OF helpers.
>>
>
> ... and then you can base on it?
>
> This is the original patchset:
>
> http://permalink.gmane.org/gmane.linux.drivers.devicetree/58764
> http://permalink.gmane.org/gmane.linux.drivers.devicetree/58763

I've looked at both. Go ahead and add my a-b line:

Acked-by: Grant Likely <grant.likely@linaro.org>
