Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3AZMJA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 07:09:00 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:47263 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3AZMI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 07:08:57 -0500
Date: Sat, 26 Jan 2013 13:08:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3, v2] x86: xor-block handling adjustments
Message-ID: <20130126120853.GE13445@gmail.com>
References: <5093E40902000078000A6147@nat28.tlf.novell.com>
 <20130124171554.GC11772@gmail.com>
 <51017028.3020001@zytor.com>
 <51024E9602000078000B97A2@nat28.tlf.novell.com>
 <5102DD08.9080204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5102DD08.9080204@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 01/25/2013 12:21 AM, Jan Beulich wrote:
> >>
> >> I don't see anything wrong, except that I can't *find* patch 3/3 either
> >> in my inbox nor on LKML...
> > 
> > I can certainly resend the whole set, but our email system even
> > got a delivery confirmation from yours on patch 3 (other than
> > e.g. from Ingo's, and all of this identical to 0...2).
> > 
> > Or see https://patchwork.kernel.org/patch/1688991/, according
> > to which you even responded to it (which is the concern Ingo was
> > referring to).
> > 
> 
> Ah yes, now I have the context.
> 
> And with that, I have to NAK the patch.  I did talk to the KVM 
> people and they confirmed that this is NOT something they 
> want.  They do not program VT-x to VMEXIT on CR0 changes.
> 
> So this is Xen-specific, and penalizing other hypervisors is 
> wrong.

Are patches #1 and #2 still OK?

Thanks,

	Ingo
