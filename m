Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab3DFKil (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 06:38:41 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39508 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3DFKij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 06:38:39 -0400
Date: Sat, 6 Apr 2013 12:40:53 +0200
From: Philip Kranz <philip.kranz@googlemail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Sebastian Wankerl <sisewank@cip.cs.fau.de>,
        linux-kernel@vger.kernel.org,
        Philip Kranz <philip.kranz@googlemail.com>,
        i4passt@lists.informatik.uni-erlangen.de, linux-parisc@vger.kernel.org
Subject: Re: [PATCH] Add non-zero module sections to sysfs
Message-ID: <20130406104053.GA24710@yoda.lan>
References: <1364994499-23708-1-git-send-email-sisewank@cip.cs.fau.de> <87mwtf3ya1.fsf@rustcorp.com.au> <515D4A7F.5070102@cip.cs.fau.de> <87vc81lj7x.fsf@rustcorp.com.au> <1365156435.1970.31.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365156435.1970.31.camel@dabdike>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Fri, Apr 05, 2013 at 12:07:15PM +0200, James Bottomley wrote:
> Just so you know: this isn't a parisc specific problem.  Gcc produces
> duplicate section names under various circumstances, but the one that
> bites us is -ffunction-sections.  Note that there are proposals to use
> -ffunction-sections on all architectures (so we can garbage collect
> unused functions) in which case you'll induce the bug identified in
> 35dead4235e2b67da7275b4122fed37099c2f462 on every architecture

I am not able to produce an object file with duplicate section names
using gcc on x86. Even with -ffunction-sections, every section gets a
unique name. Is this architecture-specific behaviour of gcc?

Greetings,
Philip

