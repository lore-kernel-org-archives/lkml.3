Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab3G1PgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 11:36:06 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:33923 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3G1PgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 11:36:04 -0400
Date: Sun, 28 Jul 2013 17:35:46 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Arend van Spriel <arend@broadcom.com>,
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130728153546.GB5224@netboy>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <1416484.XDfk5G56BI@flatron>
 <20130728131901.GA8864@netboy>
 <2529481.u8xHuXumcd@flatron>
 <CAKON4OzReTRb5JnJE+07vNJ-uDndLfqq8ha04J7K3x=WtsZEWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKON4OzReTRb5JnJE+07vNJ-uDndLfqq8ha04J7K3x=WtsZEWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 28, 2013 at 10:09:57AM -0400, jonsmirl@gmail.com wrote:
> 
> 3.z kernel is free to alter the schema. But it will have to supply the
> necessary quirks needed to keep those old dtb's functioning.

The quirks idea sounds okay to me, if it can really provide forward
compatibility. In practice, I doubt anyone will really spend the
effort to make this work. I think it would be much easier to make sure
the bindings are "future proof" in the first place.

Thanks,
Richard
