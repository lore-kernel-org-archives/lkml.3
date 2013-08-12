Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3HLRPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:15:14 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:40479 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab3HLRPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:15:10 -0400
Date: Mon, 12 Aug 2013 10:15:04 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH 1/2] include: dt-binding: input: create a DT header
 defining key codes.
Message-ID: <20130812171504.GA31418@core.coreip.homeip.net>
References: <1375798370-2231-1-git-send-email-ldewangan@nvidia.com>
 <52014E50.6030508@wwwdotorg.org>
 <5203D138.4030107@nvidia.com>
 <20130808171331.GA6960@core.coreip.homeip.net>
 <5203D487.5020507@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5203D487.5020507@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 11:25:27AM -0600, Stephen Warren wrote:
> On 08/08/2013 11:13 AM, Dmitry Torokhov wrote:
> > On Thu, Aug 08, 2013 at 10:41:20PM +0530, Laxman Dewangan wrote:
> >> On Wednesday 07 August 2013 12:58 AM, Stephen Warren wrote:
> >>> (CC'ing DT bindings maintainers too, hence quoting a bit of the patch)
> >>>
> >>> On 08/06/2013 08:12 AM, Laxman Dewangan wrote:
> >>>> Many of Key device tree bindings uses the constant number as key code
> >>>> which matches with kernel header key code and then comment as follows
> >>>> for reference/better readability:
> >>>> 	linux,code = <102>; /* KEY_HOME */
> >>>>
> >>>> Create a DT header which defines all the key code so that DT key bindings
> >>>> can use it as follows:
> >>>> 	linux,code = <KEY_HOME>;
> ...
> > I am uncomfortable that we are duplicating the whole list of keycodes
> > here. Do you think we could split keycodes and other event codes from
> > include/uapi/linux/input.h into include/uapi/linux/input-events.h and
> > unclude it directly into DTS?
> 
> Device tree files can only include headers in include/dt-bindings.
> Eventually/soon, all the DT files and the headers in the dt-bindings/
> directory will be split out into a separate git tree, which does not
> have access to include/uapi, or indeed any other Linux kernel header files.

OK, that makes it easier for me - please merge through whatever tree
that owns include/dt-bindings.

Thanks.

-- 
Dmitry
