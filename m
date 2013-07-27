Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab3G0R6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 13:58:37 -0400
Received: from mail.lang.hm ([64.81.33.126]:33797 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab3G0R6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 13:58:35 -0400
Date: Sat, 27 Jul 2013 10:57:09 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Richard Cochran <richardcochran@gmail.com>
cc: Mark Brown <broonie@kernel.org>,
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
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
In-Reply-To: <20130727173748.GA4813@netboy>
Message-ID: <alpine.DEB.2.02.1307271056060.13167@nftneq.ynat.uz>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com> <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <51F168FC.9070906@wwwdotorg.org> <20130725182920.GA24955@e106331-lin.cambridge.arm.com> <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com> <20130726045433.GB4100@netboy> <20130726171524.GB28895@obsidianresearch.com> <20130727084825.GA4707@netboy> <20130727104018.GC9858@sirena.org.uk> <20130727173748.GA4813@netboy>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jul 2013, Richard Cochran wrote:

> On Sat, Jul 27, 2013 at 11:40:18AM +0100, Mark Brown wrote:
>> On Sat, Jul 27, 2013 at 10:48:26AM +0200, Richard Cochran wrote:
>>
>>> [ I disagree about the "more thought" part. The current discussion,
>>>   coming years too late after the introduction of DT to ARM Linux, is
>>>   contrary evidence enough. ]
>>
>> We did have exactly the same discussion when the DT transition was
>> started - this isn't something that people only just realised might be
>> an issue.  There was a deliberate decision to focus on getting the
>> technology deployed to the point where it could be used as a straight
>> replacement for board files and accept that sometimes the results won't
>> be perfect and that we may need to rework as a result.
>
> Can you tell a bit more about this decision? When was it made? Who
> made it? How was it made public?

I remember seeing some of the discussion on linux-kernel at the time. I believe 
there was also a LWN article.

David Lang
