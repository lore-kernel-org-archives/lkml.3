Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab3G0JQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 05:16:40 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:60374 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3G0JQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 05:16:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAKON4OzrkHzUzKkULWCgiEpAtJ5gLxUm78R5ctd7p6trqq_gCA@mail.gmail.com>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
	<20130725175702.GC22291@e106331-lin.cambridge.arm.com>
	<51F168FC.9070906@wwwdotorg.org>
	<20130725182920.GA24955@e106331-lin.cambridge.arm.com>
	<20130725184834.GA8296@netboy>
	<20130725213753.GC17616@obsidianresearch.com>
	<20130726080115.GA5436@netboy>
	<1374831744.2923.42.camel@shinybook.infradead.org>
	<20130726130927.GC4219@netboy>
	<20130726132709.GH29916@titan.lakedaemon.net>
	<1374846070.14574.92.camel@i7.infradead.org>
	<CAKON4OzrkHzUzKkULWCgiEpAtJ5gLxUm78R5ctd7p6trqq_gCA@mail.gmail.com>
Date: Sat, 27 Jul 2013 17:16:34 +0800
Message-ID: <CACVXFVNiHg4H5rc1cxxBc=Prv4etstMFeRtk4op-tgqFp7m54A@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
From: Ming Lei <tom.leiming@gmail.com>
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Jason Cooper <jason@lakedaemon.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 10:14 PM, jonsmirl@gmail.com <jonsmirl@gmail.com> wrote:
>
> Yes, yes - that's why the schema should be written down and used as a
> validation input to dtc. Then dtc can spit out errors for non-standard
> items. There would be two versions - the standard one and a legacy one
> that includes the standard one plus the hacks that can't be undone.
>
> But more importantly it provides a framework for people creating new
> node definitions. Now they can't work in a vacuum and come up with
> random names and structure for everything.
>
> Most of the problems express in the thread would go away if the schema
> was written down and discussed. The rule going forward would be no new
> nodes that aren't part of the standard schema.

+1.

If we want to keep the schema stable, it has to be defined and described
explicitly with one language, just like syscall ABI: C type/API exported to
userspace header file.


Thanks,
-- 
Ming Lei
