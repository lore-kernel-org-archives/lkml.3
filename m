Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3G2JT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:19:26 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4194 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab3G2JTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:19:24 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <51F6338E.8020101@broadcom.com>
Date: Mon, 29 Jul 2013 11:19:10 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-Version: 1.0
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
cc: "Grant Likely" <grant.likely@secretlab.ca>,
        "Tomasz Figa" <tomasz.figa@gmail.com>,
        "Richard Cochran" <richardcochran@gmail.com>,
        "Olof Johansson" <olof@lixom.net>, "Mark Brown" <broonie@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "Ian Campbell" <ian.campbell@citrix.com>,
        "Pawel Moll" <Pawel.Moll@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Domenico Andreoli" <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>,
        "Dave P Martin" <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <2007664.vYsECFSKrV@flatron> <51F39FD8.6080808@broadcom.com>
 <2460092.aLmjrOVh1g@flatron> <51F3A82E.2000907@broadcom.com>
 <CACxGe6t0C7PTiDDaFkgoMZWUpBVokasxwZpV6HEtf3LaPi4qUw@mail.gmail.com>
 <CAKON4OymA55w_V=oP4BL2su84m8EnPgdhnQtyLWKaAJE-yNBkQ@mail.gmail.com>
In-Reply-To: <CAKON4OymA55w_V=oP4BL2su84m8EnPgdhnQtyLWKaAJE-yNBkQ@mail.gmail.com>
X-WSS-ID: 7DE8ED2431W62858550-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2013 10:01 PM, jonsmirl@gmail.com wrote:
> On Sat, Jul 27, 2013 at 3:45 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Sat, Jul 27, 2013 at 4:59 AM, Arend van Spriel <arend@broadcom.com> wrote:
>>> Let's see how many people go and scream if I say this: Too bad .dts files
>>> are not done using XML format as DT bindings could be described using XML
>>> Schema.
>>
>> Draft an example and show us how it would look!  :-)  There is
>> absolutely nothing preventing us from expressing a DT in XML format,
>> or even using XSLT to define DT schema while still using our current
>> .dts syntax. It would be trivial to do lossless translation between
>> .dts syntax and xml.
>>
>> The problem that I have with XML and XSLT is that it is very verbose
>> and not entirely friendly to mere-mortals. However, I'm more than
>> willing to be proved wrong on this point.
>
> I considered this approach a while ago and discarded it. It would work
> but it is just too much of a Frankenstein monster.

Ah, but he is so cute. At least I do not think it is more monstrous as 
the bindings files. I just browsed through a couple of arm binding files 
as I felt challenged to come up with an example. I did not get the 
impression that there is some kind of template in place to get consitent 
bindings descriptions.

> Much cleaner to modify dtc to take a schema as part of the compilation
> process. The schema language itself has no requirement to look like
> DTS syntax. Whoever wrote dtc probably has a favorite language that
> would be good for writing schemas in.

Not sure if I can follow here. I guess you mean the dts compilation, 
right? There are tools freely available to validate XML files against 
XSD specification files. As an example libxml2 has support for it. I 
suspect it is not desired to have a dependency for DTC with an 
out-of-tree library, but it could be incorporated and have DTC spew the 
validation results.

Regards,
Arend


