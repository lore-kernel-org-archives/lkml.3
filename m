Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab3KKNyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:54:40 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:47755 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3KKNyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:54:33 -0500
Date: Mon, 11 Nov 2013 14:54:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] panic: enable local IRQs for restart timeout too
Message-ID: <20131111135430.GC8781@gmail.com>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
 <1383871600-3831-4-git-send-email-felipe.contreras@gmail.com>
 <20131111131927.GA7258@gmail.com>
 <CAMP44s3hnOHs61r_7U_0P9+h3EX59VEKfAbGHyc49dvTSDqJXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s3hnOHs61r_7U_0P9+h3EX59VEKfAbGHyc49dvTSDqJXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Felipe Contreras <felipe.contreras@gmail.com> wrote:

> On Mon, Nov 11, 2013 at 7:19 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Felipe Contreras <felipe.contreras@gmail.com> wrote:
> >
> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> >
> > The changelog is missing and the title is not self-explanatory.
> 
> Either the local IRQs should be enabled for both the restart and halt
> blinks, or it shouldn't be enabled for either. Why enable them for
> halt, but not restart?
> 
> I think enabling them for restart too makes sense.

Such arguments belong into the changelog, with a description of what was 
done before and what is done after - please use the customary (verbose) 
changelog style we use in the kernel.

Thanks,

	Ingo
