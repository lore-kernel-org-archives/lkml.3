Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3J0SGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 14:06:42 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:53127 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3J0SGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 14:06:41 -0400
Date: Sun, 27 Oct 2013 19:07:06 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Rob Pearce <rob@flitspace.org.uk>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INTEL DRM DRIVERS : No LVDS hardware on Intel D410PT and
 D425KT
Message-ID: <20131027180706.GJ18189@phenom.ffwll.local>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	Rob Pearce <rob@flitspace.org.uk>, David Airlie <airlied@linux.ie>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <526D3BB6.6020902@flitspace.org.uk>
 <20131027173302.GA25812@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027173302.GA25812@kroah.com>
X-Operating-System: Linux phenom 3.10-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 10:33:02AM -0700, Greg KH wrote:
> On Sun, Oct 27, 2013 at 04:13:42PM +0000, Rob Pearce wrote:
> > From: Rob Pearce <rob@flitspace.org.uk>
> > 
> > The Intel D410PT(LW) and D425KT Mini-ITX desktop boards both show up as
> > having LVDS but the hardware is not populated. This patch adds them to
> > the list of such systems. Patch is against 3.11.4
> > 
> > Signed-off-by: Rob Pearce <rob@flitspace.org.uk>
> > ---
> > Patch revised to match the D425KT exactly as the D425KTW does have LVDS. 
> > According to Intel's documentation, the D410PTL and D410PLTW don't.
> 
> Any reason you don't want this in the stable tree as well?

None. Picked up for -fixes, thanks for the patch. Also I prefer the patch
change log in the commit message proper and less screaming in the summary
;-) All fixed while applying.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
