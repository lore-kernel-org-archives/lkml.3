Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab3G0SR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 14:17:27 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:47303 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab3G0SR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 14:17:26 -0400
Date: Sat, 27 Jul 2013 20:17:09 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: David Lang <david@lang.hm>
Cc: Mark Brown <broonie@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130727181709.GC4813@netboy>
References: <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726045433.GB4100@netboy>
 <20130726171524.GB28895@obsidianresearch.com>
 <20130727084825.GA4707@netboy>
 <20130727104018.GC9858@sirena.org.uk>
 <20130727173748.GA4813@netboy>
 <alpine.DEB.2.02.1307271056060.13167@nftneq.ynat.uz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307271056060.13167@nftneq.ynat.uz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 10:57:09AM -0700, David Lang wrote:
> On Sat, 27 Jul 2013, Richard Cochran wrote:
> 
> >On Sat, Jul 27, 2013 at 11:40:18AM +0100, Mark Brown wrote:
> >>On Sat, Jul 27, 2013 at 10:48:26AM +0200, Richard Cochran wrote:
> >>
> >>>[ I disagree about the "more thought" part. The current discussion,
> >>>  coming years too late after the introduction of DT to ARM Linux, is
> >>>  contrary evidence enough. ]
> >>
> >>We did have exactly the same discussion when the DT transition was
> >>started - this isn't something that people only just realised might be
> >>an issue.  There was a deliberate decision to focus on getting the
> >>technology deployed to the point where it could be used as a straight
> >>replacement for board files and accept that sometimes the results won't
> >>be perfect and that we may need to rework as a result.
> >
> >Can you tell a bit more about this decision? When was it made? Who
> >made it? How was it made public?
> 
> I remember seeing some of the discussion on linux-kernel at the
> time. I believe there was also a LWN article.

I must have missed it on lkml, although I do try to keep an eye on
this topic. I did find

   http://lwn.net/Articles/414016/
   http://lwn.net/Articles/426606/

but no word about unstable bindings. Maybe this was decided by the
modern method of secret committee?

Thanks,
Richard
