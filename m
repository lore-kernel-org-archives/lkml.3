Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab3HDSUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 14:20:23 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:37229 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3HDSUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 14:20:22 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20130804125346.GH23006@n2100.arm.linux.org.uk>
References: <CAOesGMgWeP-CdmOE-S7XZmJ-+1buP9a1cqavUns2gpgKrrhaxQ@mail.gmail.com>
	<20130803000731.GS23006@n2100.arm.linux.org.uk>
	<20130804125346.GH23006@n2100.arm.linux.org.uk>
Date: Sun, 4 Aug 2013 11:20:21 -0700
Message-ID: <CAOesGMhNr5-6T9s8Y9jr2pWy=baceuZwGFNj2HtnqU9DbwPLvw@mail.gmail.com>
Subject: Re: Build breakage due to latest ARM fixes
From: Olof Johansson <olof@lixom.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 4, 2013 at 5:53 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Aug 03, 2013 at 01:07:31AM +0100, Russell King - ARM Linux wrote:
>> I'll look into that.  Obviously, I never build nommu because it isn't
>> part of the build system and the nommu platform I do have - OKI67001 -
>> doesn't have mainline kernel support.  (And if it did, it would not be
>> DT, so I doubt it's submittable.)
>
> Okay, what I'm going to do is push the OKI67001 stuff into mainline
> irrespective of DT or not, so that I can then add noMMU build _and_
> boot tests to my build system, which should ensure that problems
> like that get detected before they're pushed upstream.

That seems like a step backwards. How have !MMU changes been handled
until now? Someone external has been relied on for testing?

> If people want me to care about noMMU, that's what has to happen
> because I have no other noMMU platform - if not, people can put up with
> noMMU breaking from time to time.

It seems that qemu has a couple of the stellaris platforms supported,
but as usual I suspect they can't be relied on to actually work.


-Olof
