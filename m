Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408Ab3HMXd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:33:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37952 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab3HMXd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:33:58 -0400
Message-ID: <520AC1FE.1030600@zytor.com>
Date: Tue, 13 Aug 2013 16:32:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Gibson <david@gibson.dropbear.id.au>
CC: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arend van Spriel <arend@broadcom.com>, Mark Brown <broonie@kernel.org>,
        Olof Johansson <olof@lixom.net>, mbizon@freebox.fr,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <1999586.84BnWE5EUh@thinkpad> <20130731191209.GA8027@netboy> <1409617.9untvfnOTJ@flatron> <20130731200017.GC8027@netboy> <20130731201457.GA24642@n2100.arm.linux.org.uk> <CAKON4Ow7rE9cDj_tS7kmYN4incM+ay=BK96q-ph2JxYH3xiQzg@mail.gmail.com> <20130731204817.GC24642@n2100.arm.linux.org.uk> <CAKON4Ozfe=endqnXWkcWR2HuJ489Otpcu2QsjB0DNg6jpRgG+Q@mail.gmail.com> <20130802035027.GA19115@voom.redhat.com>
In-Reply-To: <20130802035027.GA19115@voom.redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 08:50 PM, David Gibson wrote:
> On Wed, Jul 31, 2013 at 05:26:47PM -0400, jonsmirl@gmail.com
> wrote:
>> On Wed, Jul 31, 2013 at 4:48 PM, Russell King - ARM Linux 
>> <linux@arm.linux.org.uk> wrote:
>>> On Wed, Jul 31, 2013 at 04:37:36PM -0400, jonsmirl@gmail.com
>> wrote:
> [snip]
>> Alternatively you may be of the belief that it is impossible to
>> get rid of the board specific code. But x86 doesn't have any of
>> it, why should ARM?
> 
> Sure x86 has board specific code.  It's just that x86 basically
> only has one board - PC.
> 

That is one aspect (hardware standardization)... but it is more to it
than that.

	-hpa

