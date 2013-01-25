Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3AYIZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:25:39 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:57720 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab3AYIZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:25:36 -0500
Date: Fri, 25 Jan 2013 09:25:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3, v2] x86: xor-block handling adjustments
Message-ID: <20130125082530.GE25314@gmail.com>
References: <5093E40902000078000A6147@nat28.tlf.novell.com>
 <20130124171554.GC11772@gmail.com>
 <51017028.3020001@zytor.com>
 <51024E9602000078000B97A2@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51024E9602000078000B97A2@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> >>> On 24.01.13 at 18:32, "H. Peter Anvin" <hpa@zytor.com> wrote:
> > On 01/24/2013 11:15 AM, Ingo Molnar wrote:
> >> 
> >> * Jan Beulich <JBeulich@suse.com> wrote:
> >> 
> >>> v2 of this series is merely updated on top of the changes between
> >>> 3.6 and 3.7-rc (which includes the dropping of what previously was
> >>> the second patch in a four patch series).
> >>>
> >>> 1: unify SSE-base xor-block routines
> >>> 2: add alternative SSE implementation only prefetching once per 64-byte line
> >>> 3: make virtualization friendly
> >>>
> >>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> >> 
> >> Looks useful. Wondering what the status is: hpa, was your 
> >> concern resolved, do you think we can apply these?
> >> 
> > 
> > I don't see anything wrong, except that I can't *find* patch 
> > 3/3 either in my inbox nor on LKML...

I think it's just that this is an older thread I found, possibly 
out of your folder already.

They are looking good to me and I've applied them to x86/asm to 
give it some testing as well. Please holler if you see something 
funny.

Thanks,

	Ingo
