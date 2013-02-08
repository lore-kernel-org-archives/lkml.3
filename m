Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946708Ab3BHQYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 11:24:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:51566 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946552Ab3BHQYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 11:24:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,630,1355126400"; 
   d="scan'208";a="259776230"
Date: Fri, 8 Feb 2013 18:24:27 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH] x86: Add support for 64bit get_user() on x86-32
Message-ID: <20130208162427.GG9135@intel.com>
References: <1355312043-11467-1-git-send-email-ville.syrjala@linux.intel.com>
 <20130207165347.GF9135@intel.com>
 <5113EB64.2080002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5113EB64.2080002@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 09:59:00AM -0800, H. Peter Anvin wrote:
> On 02/07/2013 08:53 AM, Ville Syrjälä wrote:
> > 
> > Based on the initial response there seems to be some interest towards
> > it at least. So I'm wondering what's the next step. Is it OK as is,
> > or does it need more work, or would people want to extend it to include
> > more of the original work?
> > 
> > I have quite a lot of other stuff on my plate currently, so it'd
> > actually be nice if I could find someone to adopt this patch,
> > especially if there's interest in increasing the scope.
> > 
> 
> Well, we can put it in and see what happens.  It looks good from what I
> can see.
> 
> How have you tested it?

I've tried it with my drm/kms atomic pageflip/modeset code. I also had
a small test module that did a couple of different sized get_user()
calls, but I'll be damned if I can find it again.

-- 
Ville Syrjälä
Intel OTC
