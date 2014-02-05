Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbaBEFl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 00:41:29 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38744 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaBEFl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 00:41:27 -0500
Date: Wed, 5 Feb 2014 06:41:23 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Intel-gfx] [PATCH v3 2/6] x86: Add Intel graphics stolen memory
 quirk for gen2 platforms
Message-ID: <20140205054123.GA30022@gmail.com>
References: <1386085793-317-3-git-send-email-ville.syrjala@linux.intel.com>
 <1389108512-20039-1-git-send-email-ville.syrjala@linux.intel.com>
 <20140204124707.GG3891@intel.com>
 <20140204130205.GR17001@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140204130205.GR17001@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Vetter <daniel@ffwll.ch> wrote:

> On Tue, Feb 04, 2014 at 02:47:07PM +0200, Ville Syrjälä wrote:
> > Hi x86 folks,
> > 
> > Ping on getting the gen2 stolen memory early quirk patches into 
> > the x86 tree.
> > 
> > From our side Daniel and Chris both seemed happy with them, so I'd 
> > like to get them in at some point.
> 
> Yup, I think this is ready for 3.15. And since there's no direct 
> depency really between the i915 parts and the x86 early reserve 
> stuff they can go both in through relevant trees - i915 will simply 
> fail the stolen setup if the range isn't properly reserved.
> 
> A stable branch somewhere would be good though so that I can pull it 
> into our integration tree for testing.

Please post the x86 bits separately in a standalone series, if they 
can and should be applied standalone.

Thanks,

	Ingo
