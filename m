Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3G1I5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 04:57:13 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:53779 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3G1I5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 04:57:09 -0400
Date: Sun, 28 Jul 2013 10:56:52 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>, Olof Johansson <olof@lixom.net>,
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
Message-ID: <20130728085650.GA4683@netboy>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F39FD8.6080808@broadcom.com>
 <20130727183059.GD4813@netboy>
 <1441731.8CGUI1tUxh@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1441731.8CGUI1tUxh@flatron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 11:51:06AM -0700, Tomasz Figa wrote:
> On Saturday 27 of July 2013 20:31:01 Richard Cochran wrote:
> > 
> > Frankly, I am really surprised and shocked at the cavalier attitude
> > expressed here WRT DT bindings in released kernels. Think about the
> > *users* of this code. Not everyone working with ARM Linux is a kernel
> > developer or a DT guru. There is really no indication at all that the
> > ARM Linux DT stuff released so far are not stable and trustworthy.

Read the above again, please.

> Well, it depends on how we use the DT. There are (at least) two possible 
> usage scenarios:
> 
>  a) using DT as direct replacement for board files - this means that you 
>     are free to say that DTSes are strictly coupled with kernel version 
>     and you are free to modify the bindings - see the analogy to board 
>     files, where you could modify the platform data structures and could 
>     not directly copy board file from one kernel version to another,
> 
>  b) using DT as an ABI - this is the original way, i.e. define stable 
>     bindings and make sure that anu DTB built for older kernel will work,
>     with equal or greater set of functionality on newer kernels.
> 
> Now I believe in this thread the point whether we should use a) or b) or a 
> combination of both has been raised.

If you seriously want to pursue a) then you are thinking only of
yourself.

Please consider the needs of the people trying to use your code in
actual practice.

Thanks,
Richard

