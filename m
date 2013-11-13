Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab3KMLTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:19:41 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:49559 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3KMLTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:19:38 -0500
Date: Wed, 13 Nov 2013 12:19:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Cohen <david.a.cohen@linux.intel.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 0/3] Bring SFI support to out-of-tree driver modules on
 Intel Mid
Message-ID: <20131113111934.GB9654@gmail.com>
References: <1384294420-9124-1-git-send-email-david.a.cohen@linux.intel.com>
 <20131113081445.GA19388@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113081445.GA19388@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Nov 12, 2013 at 02:13:37PM -0800, David Cohen wrote:
>
> > Hi,
> > 
> > This patchset extends sfi_device() macro support to driver modules. 
> > The main use case is to allow external driver modules to be enumerated 
> > by SFI on Intel Mid platforms.
> 
> How about you merge those module again?  Remember code added to the 
> kernel without users isn't testable, and out of tree modules do not 
> bring us any value add.

I wanted to make the exact same point.

I recently had to revert a similarly misguided attempt which added bloat 
for out of tree modules without merging it in tree, see commit 
b5dfcb09debc ("Revert "x86/UV: Add uvtrace support").

Thanks,

	Ingo
