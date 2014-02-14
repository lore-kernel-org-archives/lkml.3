Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaBNTq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 14:46:27 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:34111 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaBNTq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 14:46:26 -0500
Date: Fri, 14 Feb 2014 21:46:45 +0100
From: Luis Ortega <luiorpe1@upv.es>
To: Jani Nikula <jani.nikula@intel.com>
Cc: daniel.vetter@ffwll.ch, airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Regression 3.14-rc2] drm/i915: Brightness adjustment is broken
 in 945GM
Message-ID: <20140214204645.GA890@Len.lan_dn>
References: <20140213153458.GA724@Len.lan_dn>
 <87lhxfvytk.fsf@intel.com>
 <20140213162422.GA765@Len.lan_dn>
 <20140213205800.GA694@Len.lan_dn>
 <87ha82w4ov.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87ha82w4ov.fsf@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Feb 14, 2014 at 09:09:52AM +0200, Jani Nikula wrote:
> 
> It seems that it will be better to track this in bugzilla rather than
> the mailing lists. Please file a bug on DRM/Intel component at
> https://bugs.freedesktop.org/enter_bug.cgi?product=DRI. Attach these
> files.

Done. We can continue tracking this issue in
https://bugs.freedesktop.org/show_bug.cgi?id=75001

FYI, I re-bisected this issue and a different commit came up as the offendor.
It's all in the bugzilla report.

Luis
