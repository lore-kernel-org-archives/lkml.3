Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077Ab3HNBts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 21:49:48 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51238 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814Ab3HNBtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 21:49:46 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <520AE238.4030304@roeck-us.net>
Date: Tue, 13 Aug 2013 18:49:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
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
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <1999586.84BnWE5EUh@thinkpad> <20130731191209.GA8027@netboy> <1409617.9untvfnOTJ@flatron> <20130731200017.GC8027@netboy> <20130731201457.GA24642@n2100.arm.linux.org.uk> <CAKON4Ow7rE9cDj_tS7kmYN4incM+ay=BK96q-ph2JxYH3xiQzg@mail.gmail.com> <20130731204817.GC24642@n2100.arm.linux.org.uk> <CAKON4Ozfe=endqnXWkcWR2HuJ489Otpcu2QsjB0DNg6jpRgG+Q@mail.gmail.com> <20130802035027.GA19115@voom.redhat.com> <520AC1FE.1030600@zytor.com>
In-Reply-To: <520AC1FE.1030600@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 04:32 PM, H. Peter Anvin wrote:
> On 08/01/2013 08:50 PM, David Gibson wrote:
>> On Wed, Jul 31, 2013 at 05:26:47PM -0400, jonsmirl@gmail.com
>> wrote:
>>> On Wed, Jul 31, 2013 at 4:48 PM, Russell King - ARM Linux
>>> <linux@arm.linux.org.uk> wrote:
>>>> On Wed, Jul 31, 2013 at 04:37:36PM -0400, jonsmirl@gmail.com
>>> wrote:
>> [snip]
>>> Alternatively you may be of the belief that it is impossible to
>>> get rid of the board specific code. But x86 doesn't have any of
>>> it, why should ARM?
>>
>> Sure x86 has board specific code.  It's just that x86 basically
>> only has one board - PC.
>>
>
> That is one aspect (hardware standardization)... but it is more to it
> than that.
>
I have to deal with lots of embedded / non-PC x86 based systems. Worst one
I encountered so far was a board where the VGA memory space was re-used
for an eeprom. The upcoming next generation hardware I'll have to support
is so far off-standard that I'll probably have to define a new platform
type (similar to OLPC or CE4100).

No, it is not all PC. Not anymore. Intel has started to sell into
the embedded space, where PC compatibility is not a requirement.

Guenter

