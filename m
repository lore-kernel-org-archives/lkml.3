Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab3HDMx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 08:53:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40250 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab3HDMx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 08:53:56 -0400
Date: Sun, 4 Aug 2013 13:53:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Build breakage due to latest ARM fixes
Message-ID: <20130804125346.GH23006@n2100.arm.linux.org.uk>
References: <CAOesGMgWeP-CdmOE-S7XZmJ-+1buP9a1cqavUns2gpgKrrhaxQ@mail.gmail.com> <20130803000731.GS23006@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130803000731.GS23006@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 03, 2013 at 01:07:31AM +0100, Russell King - ARM Linux wrote:
> I'll look into that.  Obviously, I never build nommu because it isn't
> part of the build system and the nommu platform I do have - OKI67001 -
> doesn't have mainline kernel support.  (And if it did, it would not be
> DT, so I doubt it's submittable.)

Okay, what I'm going to do is push the OKI67001 stuff into mainline
irrespective of DT or not, so that I can then add noMMU build _and_
boot tests to my build system, which should ensure that problems
like that get detected before they're pushed upstream.

If people want me to care about noMMU, that's what has to happen
because I have no other noMMU platform - if not, people can put up with
noMMU breaking from time to time.
