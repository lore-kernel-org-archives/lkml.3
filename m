Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaFBXM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 19:12:28 -0400
Received: from mail1-ar.fullrate.dk ([90.185.3.41]:40905 "EHLO
	mail1-ar.fullrate.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaFBXM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 19:12:27 -0400
Message-ID: <538D04D4.1060906@molgaard.org>
Date: Tue, 03 Jun 2014 01:12:20 +0200
From: =?ISO-8859-1?Q?Sune_M=F8lgaard?= <sune@molgaard.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0 SeaMonkey/2.29a1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Summarizing deprecations
References: <53893895.3040202@molgaard.org> <20140531022151.GA32348@kroah.com> <538944E2.2070706@molgaard.org> <20140531033711.GA1697@kroah.com>
In-Reply-To: <20140531033711.GA1697@kroah.com>
X-Enigmail-Version: 1.7a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again, and thank you still for interacting,

Greg KH wrote:
> What specific drivers are they?  Why are the drivers out of the tree?
> I'll gladly add them to the drivers/staging/ directory as long as the
> license of them allows me to do so.  That way api changes will happen
> automatically for them.

For at least one of the manufacturers, I have already pointed them in
your direction with regards to the previously mentioned project. They
lamented that they would love to take you up on your offer, but that
their legal department was less than enthusiastic, based on fear of
repercussions from their chip suppliers.

This particular company could be a candidate for positive nudging from
stronger entities than myself, as just one guy.

> In other words, no matter what we do, things outside of the kernel tree
> will break.  This is on the vendor, not us now.  They know where to find
> us, we have no idea who they are.

I do not propose to adopt backwards compatibility, but see below (as
well as my initial proposal, with a thought to my subsequent
clarifications).

> Then they are on their own as they are violating our license when
> redistributing such a monstrosity.  They know the issues involved, and
> are willing to pay the price to do such a thing.  There's nothing we can
> do about them, sorry.  Go bug the vendor, not us.

I wish it was so simple. My experience has been that they are, as you
say, on their own, but in a much more poignant sense that you suggested.

First of all, many *consumer* hardware vendors will be more than happy
to be "on their own" wrt to Linux and keep their focus on Windows. This
is their choice to make, but in certain circumstances, we do happen to
have a need for interaction (OpenCL support in graphics drivers, for
instance).

What I seem to have ascertained is, that those, major, players in the
field will, usually, assign a very low number of people to the task of
maintaining compatibility with newer kernels, with no corporate support
at all.

This, obviously, provides the raison d'etre for the reverse-engineered
open-source drivers, but as we stand in the here and now, those have a
lot of work to do to come up to speed.

We agree completely, that the way to go is for the vendors to engage
with the OSS driver hackers, but in the interim, some of us will still
need their closed drivers, and this is where my initial RFC came from:

Compilation of the closed drivers, as well as (as seen in a recent
nVidia case) functionality, will be impacted by system call changes.

You are fully correct that we shouldn't keep old and deprecated
functionality around for the sake of those who choose to distribute
closed drivers.

It stands to reason, though, that there may not only be legal obstacles
to supporting OSS drivers, but also that corporate resources allocated
to keeping their "monstrosity" current may be severely lacking.

As a pragmatic *interim* solution, I therefore stand by my initial
proposal - both as a sign of being reasonably, but also for that level
of reasonableness to be a fulcrum for expecting signs (and results) of
good will to come from them as well.

As it stands, I have authored a number of patches that I have posted to
the nVidia forums - most based on deeper analysis by people in the same
forums, but I happen to think that if my proposal gained traction,
nVidia could actually do that work themselves - facilitating ease of use
for those of us who rely on their drivers while we wait for the dawn of
the revolution...

At any rate, it should preclude a marketing drone from referring to an
unnamed engineer classifying a problem as a bug in the kernel, which is
obviously, in reality, caused by a failure to use a new form of ACPI call.

> 
> And buy better hardware next time :)

Sure - do you think a Kickstarter campaign to entice Danish resellers to
stock better hardware (and advertise it as having OSS Linux drivers)
against profit margins, possibly with a secondary goal of sending such
hardware my way, could get any traction, or did you just, unbecomingly,
get elitist on me?

Sincerely,

Sune Mølgaard
