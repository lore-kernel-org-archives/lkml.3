Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab3KHThZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:37:25 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:35420 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab3KHThY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:37:24 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19tRQCW9FWzFQZK5N9HqvfFigvzq4Mx3Bw=
Date: Fri, 8 Nov 2013 14:37:22 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Olof Johansson <olof@lixom.net>
Cc: Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Subject: Re: common location for devicetree files
Message-ID: <20131108193722.GK10335@titan.lakedaemon.net>
References: <1438803E-C904-428B-B042-891978BC15DF@codeaurora.org>
 <CAOesGMgyqXS8tq0Ru=ibypV89-oAJ8bzxhdFTnSAvfOobEC+Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgyqXS8tq0Ru=ibypV89-oAJ8bzxhdFTnSAvfOobEC+Lw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 11:33:00AM -0800, Olof Johansson wrote:
> On Thu, Nov 7, 2013 at 3:21 PM, Kumar Gala <galak@codeaurora.org> wrote:
> > As we start having more sharing of device trees between architectures (arm & arm64, arm & powerpc, guessing maybe mips & arm) we need dts to live in location that
> >
> > I was wondering what people felt about doing:
> >
> >         arch/dts/<VENDOR>/
> >
> > as a common location that could be shared.  I'm up for other suggestions.
> 
> dts isn't an architecture, so having it directly under arch/ doesn't
> make sense. I know it's the first common parent of a lot of platforms
> though.
> 
> I'd be ok with adding a toplevel dts/ directory for this, for lack of
> better options. It doesn't really fit under firmware, lib, kernel,
> scripts, tools...

I'll admit I shied away from that thought (dts/) for fear of the wrath
of the greybeards.  :)

thx,

Jason.
