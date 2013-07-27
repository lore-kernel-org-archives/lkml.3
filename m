Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3G0SbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 14:31:19 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:54693 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3G0SbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 14:31:17 -0400
Date: Sat, 27 Jul 2013 20:31:01 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
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
Message-ID: <20130727183059.GD4813@netboy>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <CAOesGMhEr3DiFm5uSgoHPFUMY4jWu4HkeTU2UmOGj=dS75Vk+g@mail.gmail.com>
 <20130727050406.GB4221@netboy>
 <2007664.vYsECFSKrV@flatron>
 <51F39FD8.6080808@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F39FD8.6080808@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 12:24:24PM +0200, Arend van Spriel wrote:
> 
> That is a nice summary of how we got from null to now and Richard
> seems to be simply saying: let's stop mucking about and make this a
> project with a well-defined process of dealing with staging and
> stable bindings and keep stable bindings stable.

Yes, that is right.

Frankly, I am really surprised and shocked at the cavalier attitude
expressed here WRT DT bindings in released kernels. Think about the
*users* of this code. Not everyone working with ARM Linux is a kernel
developer or a DT guru. There is really no indication at all that the
ARM Linux DT stuff released so far are not stable and trustworthy.

It is not nice to provide such a mess, and the idea that we *must*
have a mess because the whole system in still in development is bogus,
IMHO. Just make sure that the mainline kernel is really working and
that the DT bindings *there* are for keeps.

It is your job as kernel developers.

Thanks,
Richard
