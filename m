Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab3G0Tpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 15:45:41 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41256 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3G0Tpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 15:45:39 -0400
MIME-Version: 1.0
In-Reply-To: <51F3A82E.2000907@broadcom.com>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <2007664.vYsECFSKrV@flatron> <51F39FD8.6080808@broadcom.com>
 <2460092.aLmjrOVh1g@flatron> <51F3A82E.2000907@broadcom.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 27 Jul 2013 13:45:18 -0600
X-Google-Sender-Auth: sP6kCMS5QcJUwwZU7pD1I5wHLJE
Message-ID: <CACxGe6t0C7PTiDDaFkgoMZWUpBVokasxwZpV6HEtf3LaPi4qUw@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
To: Arend van Spriel <arend@broadcom.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 4:59 AM, Arend van Spriel <arend@broadcom.com> wrote:
> Let's see how many people go and scream if I say this: Too bad .dts files
> are not done using XML format as DT bindings could be described using XML
> Schema.

Draft an example and show us how it would look!  :-)  There is
absolutely nothing preventing us from expressing a DT in XML format,
or even using XSLT to define DT schema while still using our current
.dts syntax. It would be trivial to do lossless translation between
.dts syntax and xml.

The problem that I have with XML and XSLT is that it is very verbose
and not entirely friendly to mere-mortals. However, I'm more than
willing to be proved wrong on this point.

g.
