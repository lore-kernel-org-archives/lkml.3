Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab3HNOsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:48:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45867 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932499Ab3HNOsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:48:39 -0400
Message-ID: <520B985B.3080104@zytor.com>
Date: Wed, 14 Aug 2013 07:46:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: David Gibson <david@gibson.dropbear.id.au>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Domenico Andreoli <cavokz@gmail.com>, mbizon@freebox.fr,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <1999586.84BnWE5EUh@thinkpad> <20130731191209.GA8027@netboy> <1409617.9untvfnOTJ@flatron> <20130731200017.GC8027@netboy> <20130731201457.GA24642@n2100.arm.linux.org.uk> <CAKON4Ow7rE9cDj_tS7kmYN4incM+ay=BK96q-ph2JxYH3xiQzg@mail.gmail.com> <20130731204817.GC24642@n2100.arm.linux.org.uk> <CAKON4Ozfe=endqnXWkcWR2HuJ489Otpcu2QsjB0DNg6jpRgG+Q@mail.gmail.com> <20130802035027.GA19115@voom.redhat.com> <520AC1FE.1030600@zytor.com> <520AE238.4030304@roeck-us.net>
In-Reply-To: <520AE238.4030304@roeck-us.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 06:49 PM, Guenter Roeck wrote:
>
>> That is one aspect (hardware standardization)... but it is more to it
>> than that.
>
> I have to deal with lots of embedded / non-PC x86 based systems. Worst one
> I encountered so far was a board where the VGA memory space was re-used
> for an eeprom. The upcoming next generation hardware I'll have to support
> is so far off-standard that I'll probably have to define a new platform
> type (similar to OLPC or CE4100).
> 
> No, it is not all PC. Not anymore. Intel has started to sell into
> the embedded space, where PC compatibility is not a requirement.
> 

We try to encourage vendors to do the right thing, where "the right
thing" means, among other things, not to do gratuitously different
things.  With increasing amounts of the platform moving into the CPU and
PCH this is of course also becoming more and more rare.

Even on actual PCs we have seen some truly "special" facepalms.  There
was the Olivetti machine which used the GPIO for "fast A20" to control
the screen backlight, for example.  That one was fun to deal with.

	-hpa

