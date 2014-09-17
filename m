Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaIQQUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:20:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36647 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbaIQQUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:20:50 -0400
Date: Wed, 17 Sep 2014 09:20:58 -0700
From: Darren Hart <dvhart@infradead.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jan van den Berg <janvdberg@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: thinkpad_acpi.c: fixed spacing coding style issue
Message-ID: <20140917162058.GB5697@vmdeb7>
References: <1410904868-10406-1-git-send-email-janvdberg@gmail.com>
 <20140916221236.GB12780@vmdeb7>
 <20140917104550.GB8594@khazad-dum.debian.net>
 <CAA-PxD-e-SGQO3eO0PLn9GVdSwXOT=y+Ycsxkm7KtfKhbCcNdw@mail.gmail.com>
 <20140917124835.GA30371@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917124835.GA30371@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 09:48:35AM -0300, Henrique de Moraes Holschuh wrote:
> On Wed, 17 Sep 2014, Jan van den Berg wrote:
> > I will try and make _real_ contribution next time. (With this being my
> > first ever submission to the kernel: at least now I understand the kernel
> > workflow.)
> 
> There's nothing wrong with your patch by itself.  And git does try to help
> us take such patches (there's "git blame -w")... but ignoring whitespace
> changes doesn't always work as well as one would like.
> 
> That said, Darren has already queued your patch, and I am _not_ going to ask
> him to drop it.  So, as far as I'm concerned, the patch has been accepted,
> and that's it.

Henrique,

Thanks for the feedback. I had considered rejecting the patch for the reason you
describe, but opted to take it this time. I haven't established all my
maintainer policies yet, so they will change a little over time as we find what
works and what causes us more pain. Personally, I like to see the cleanups, but
generally agree that cleanups should typically be [PATCH 1/X] of a series.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
