Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3IBGTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 02:19:40 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:65475 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab3IBGTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 02:19:37 -0400
Date: Mon, 2 Sep 2013 08:19:50 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, airlied@redhat.com,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 0/2] vgaarb: Fixes for partial VGA opt-out
Message-ID: <20130902061950.GH9374@phenom.ffwll.local>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>, airlied@redhat.com,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20130815222835.27642.15330.stgit@bling.home>
 <20130830124119.GH11428@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130830124119.GH11428@intel.com>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 03:41:19PM +0300, Ville Syrjälä wrote:
> On Thu, Aug 15, 2013 at 04:37:47PM -0600, Alex Williamson wrote:
> > I'm trying to add support for VGA arbitration on newer Intel graphics
> > devices.  The existing code attempts to do this, but appear to have
> > not been updated since GMCH devices roamed the Earth.  On newer
> > devices like Haswell, we can disable VGA memory through an MSR on the
> > device, but we rely on the VGA arbiter to manage VGA IO using the PCI
> > COMMAND register.  In trying to unregister legacy VGA memory, I found
> > that the VGA arbiter still wanted to disable both memory and IO on
> > the device and that it forgot to actually program the device to
> > disable IO when the decoding is updated.  This series attempts to fix
> > both of those.  Thanks,
> 
> The series looks good to me.
> 
> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Merged to dinq with Dave's irc-ack. I'll shuffle my tree a bit so that
this will be part of my 3.12 latecomers pull request to Dave.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
