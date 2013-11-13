Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab3KMUgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 15:36:42 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:53530 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3KMUge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 15:36:34 -0500
Date: Wed, 13 Nov 2013 21:37:06 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [Intel-gfx] [PATCH] x86/early quirk: use gen6 stolen detection
 for VLV
Message-ID: <20131113203706.GJ7251@phenom.ffwll.local>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	hpa@zytor.com
References: <1384280259-800-1-git-send-email-jbarnes@virtuousgeek.org>
 <20131113192259.GI7819@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131113192259.GI7819@intel.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 09:22:59PM +0200, Ville Syrjälä wrote:
> On Tue, Nov 12, 2013 at 10:17:39AM -0800, Jesse Barnes wrote:
> > We've always been able to use either method on VLV, but it appears more
> > recent BIOSes only support the gen6 method, so switch over to that.
> 
> I'm not sure what tha means since we've been using the gen6 method for
> a long time now (except for the early quirk).

lalalala

> But anyways this matches the specs so:
> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Picked up for -fixes, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
