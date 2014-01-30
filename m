Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaA3PwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:52:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56241 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752733AbaA3PwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:52:05 -0500
Date: Thu, 30 Jan 2014 10:52:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Vetter <daniel@ffwll.ch>
cc: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] Excessive WARN()s in Intel 915 driver
In-Reply-To: <20140130152258.GS17001@phenom.ffwll.local>
Message-ID: <Pine.LNX.4.44L0.1401301051000.1833-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Daniel Vetter wrote:

> Ok, I seem to have been truly blind all the time. This seems to have been
> fallout from
> 
> commit b6c5164d7bf624f3e1b750787ddb983150c5117c
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Fri Apr 12 18:48:43 2013 +0200
> 
>     drm/i915: Fixup Oops in the pipe config computation
> 
> Meanwhile we've moved the overall infrastructure ahead again quite a bit,
> so I think it's time to give the full atomic modeset paths another shot.
> But I'll be travelling to fosdem the next few days, so this will take a
> bit of time.
> 
> As long as there's not real bad side-effects I guess we simply need to
> live with the WARN for a tad longer.

Okay.  Let me know when you've got something else ready to test.

Alan Stern

