Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaBDNCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:02:17 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:44310 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbaBDNCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:02:14 -0500
Date: Tue, 4 Feb 2014 14:02:05 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Intel-gfx] [PATCH v3 2/6] x86: Add Intel graphics stolen memory
 quirk for gen2 platforms
Message-ID: <20140204130205.GR17001@phenom.ffwll.local>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
References: <1386085793-317-3-git-send-email-ville.syrjala@linux.intel.com>
 <1389108512-20039-1-git-send-email-ville.syrjala@linux.intel.com>
 <20140204124707.GG3891@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140204124707.GG3891@intel.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 02:47:07PM +0200, Ville Syrjälä wrote:
> Hi x86 folks,
> 
> Ping on getting the gen2 stolen memory early quirk patches into the x86
> tree.
> 
> From our side Daniel and Chris both seemed happy with them, so I'd like
> to get them in at some point.

Yup, I think this is ready for 3.15. And since there's no direct depency
really between the i915 parts and the x86 early reserve stuff they can go
both in through relevant trees - i915 will simply fail the stolen setup if
the range isn't properly reserved.

A stable branch somewhere would be good though so that I can pull it into
our integration tree for testing.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
