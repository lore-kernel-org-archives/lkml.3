Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab3HAJ6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 05:58:04 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4810 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab3HAJ6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 05:58:01 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <51FA3117.1080905@broadcom.com>
Date: Thu, 1 Aug 2013 11:57:43 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-Version: 1.0
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "Richard Cochran" <richardcochran@gmail.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        "Ian Campbell" <ian.campbell@citrix.com>,
        "Pawel Moll" <Pawel.Moll@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tomasz Figa" <tomasz.figa@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "Domenico Andreoli" <cavokz@gmail.com>,
        "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>,
        "Mark Brown" <broonie@kernel.org>, "Olof Johansson" <olof@lixom.net>,
        mbizon@freebox.fr, "Dave P Martin" <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <1999586.84BnWE5EUh@thinkpad> <20130731191209.GA8027@netboy>
 <1409617.9untvfnOTJ@flatron> <20130731200017.GC8027@netboy>
 <20130731201457.GA24642@n2100.arm.linux.org.uk>
 <CAKON4Ow7rE9cDj_tS7kmYN4incM+ay=BK96q-ph2JxYH3xiQzg@mail.gmail.com>
 <20130731204817.GC24642@n2100.arm.linux.org.uk>
 <CAKON4Ozfe=endqnXWkcWR2HuJ489Otpcu2QsjB0DNg6jpRgG+Q@mail.gmail.com>
In-Reply-To: <CAKON4Ozfe=endqnXWkcWR2HuJ489Otpcu2QsjB0DNg6jpRgG+Q@mail.gmail.com>
X-WSS-ID: 7DE4F03F1R075667948-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 11:26 PM, jonsmirl@gmail.com wrote:
> Alternatively you may be of the belief that it is impossible to get
> rid of the board specific code. But x86 doesn't have any of it, why
> should ARM?

Well, I am curious whether that will stay that way once x86 is truly 
moving into the embedded arena (if ever).

Regards,
Arend

