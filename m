Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946837Ab3BHSXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 13:23:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:46167 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946764Ab3BHSXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 13:23:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,630,1355126400"; 
   d="scan'208";a="254425014"
Date: Fri, 8 Feb 2013 20:23:08 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] x86: Add support for 64bit get_user() on x86-32
Message-ID: <20130208182308.GI9135@intel.com>
References: <1355312043-11467-1-git-send-email-ville.syrjala@linux.intel.com>
 <20130207165347.GF9135@intel.com>
 <5113EB64.2080002@zytor.com>
 <20130208162427.GG9135@intel.com>
 <5115361D.8060501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5115361D.8060501@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 09:30:05AM -0800, H. Peter Anvin wrote:
> On 02/08/2013 08:24 AM, Ville Syrjälä wrote:
> >>
> >> How have you tested it?
> > 
> > I've tried it with my drm/kms atomic pageflip/modeset code. I also had
> > a small test module that did a couple of different sized get_user()
> > calls, but I'll be damned if I can find it again.
> > 
> 
> Did you see the warning spewage for pointers when you built it?

Apparently my config was too small to genenerate enough of those to catch
my eye. Most of those seem to come from drivers that have pointers in their
ioctl structs, no?

-- 
Ville Syrjälä
Intel OTC
