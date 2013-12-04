Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab3LDPPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:15:55 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:36577 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab3LDPPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:15:54 -0500
Date: Wed, 4 Dec 2013 16:15:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] x86: Add Intel graphics stolen memory quirk for
 gen2 platforms
Message-ID: <20131204151550.GA5502@gmail.com>
References: <1386085793-317-1-git-send-email-ville.syrjala@linux.intel.com>
 <1386085793-317-3-git-send-email-ville.syrjala@linux.intel.com>
 <20131204090814.GA32218@gmail.com>
 <20131204151213.GW10036@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131204151213.GW10036@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ville Syrjälä <ville.syrjala@linux.intel.com> wrote:

> On Wed, Dec 04, 2013 at 10:08:14AM +0100, Ingo Molnar wrote:
> > 
> > * ville.syrjala@linux.intel.com <ville.syrjala@linux.intel.com> wrote:
> > 
> > > v2: Rewrite to use the TOM-TSEG_SIZE-stolen_size and TOUD methods
> > 
> > I guess v2 is a reaction to my review feedback? I got no reply to my 
> > mail from you so I'm not sure and I'd like to know whether all 
> > feedback was addressed.
> 
> Actually this was mostly insipired by a private mail from hpa. I forgot
> to reply to your mail, sorry about that.
> 
> But anyways, I think apart from your comment about the KB/MB macros,
> the rest of the comments no longer apply. [...]

Ok.

> [...] And as far as those macros go, there seem to be similar macros 
> already sprinkled around in various places, so I'm not sure how big 
> of a fallout we'd have if I just stick them into kernel.h.

That was a separate suggestion, outside the scope of this series.

Anyway, this v2 series looks good.

Thanks,

	Ingo
