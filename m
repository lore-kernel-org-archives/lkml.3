Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966Ab3GZNnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:43:09 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:46956 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758806Ab3GZNnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:43:05 -0400
Message-ID: <51F27CE2.6050908@gmail.com>
Date: Fri, 26 Jul 2013 08:42:58 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: DT bindings as ABI [was: Do we have people interested in device
 tree janitoring / cleanup?]
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com> <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <51F168FC.9070906@wwwdotorg.org> <20130725182920.GA24955@e106331-lin.cambridge.arm.com> <20130725184834.GA8296@netboy> <20130725213753.GC17616@obsidianresearch.com> <20130726045433.GB4100@netboy>
In-Reply-To: <20130726045433.GB4100@netboy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 11:54 PM, Richard Cochran wrote:
> On Thu, Jul 25, 2013 at 03:37:53PM -0600, Jason Gunthorpe wrote:
> 
>> We use DT has a kernel configuration input. Our environment is
>> designed to guarantee 100% that the kernel and DT match exactly. DT
>> very deliberately isn't an ABI boundary in our systems.
> 
> It is nice that you use DT in that way, but that is not how DT is
> supposed to work. If you must keep your DT in sync with the kernel,
> then there is no advantage over the old platfrom device method. At
> least that had the virtue of being a C language interface (ABI), and
> some mistakes were be caught by the compiler.

I agree, but there is one advantage in that how the data in the DT is
described is unified. Before, how every platform defined and created
devices was slightly different. Now you know where to go look and don't
have things all over the place and hidden by custom macros. We could
have fixed all that in C without DT, but DT conversion forced the clean-up.

>> We've been doing this for years and have a proven in the field track
>> record of upgrades from pre-2.6.16 to 3.7 and beyond with multiple
>> SOCs. The same bootloader that was shipped to support non-DT 2.6.16
>> boots DT 3.7 just fine.
> 
> Try that with Freescale PowerPCs.  Good luck.
> 
> Heck, even Paul's OMAP test reports have been spoiled by his not
> deleting old dtb files. Of course, that is his fault (and not DT's, no
> never).
>  
>> For closed system embedded DT has proven *WONDERFUL*.
> 
> I too work on commercial embedded systems, and DT has proven to be
> one gigantic *PITA*.

Due to ABI breakage or other reasons?

Rob

