Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762155Ab3JPVBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 17:01:54 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:35228 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761921Ab3JPVBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 17:01:52 -0400
Date: Wed, 16 Oct 2013 23:02:13 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: daniel.vetter@ffwll.ch, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, przanoni@gmail.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [v3.10][v3.11][v3.12][Regression][PATCH 1/1] Revert "Revert
 "drm/i915: revert eDP bpp clamping code changes""
Message-ID: <20131016210213.GR4830@phenom.ffwll.local>
Mail-Followup-To: Joseph Salisbury <joseph.salisbury@canonical.com>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	przanoni@gmail.com, airlied@linux.ie,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
References: <cover.1381939165.git.joseph.salisbury@canonical.com>
 <397b1b6f028317a3ef897cdaf79eb1e5519e587d.1381939165.git.joseph.salisbury@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <397b1b6f028317a3ef897cdaf79eb1e5519e587d.1381939165.git.joseph.salisbury@canonical.com>
X-Operating-System: Linux phenom 3.10-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 04:34:57PM -0400, Joseph Salisbury wrote:
> BugLink: http://bugs.launchpad.net/bugs/1195483
> 
> This reverts commit 657445fe8660100ad174600ebfa61536392b7624.
> 
> Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Paulo Zanoni <przanoni@gmail.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: stable@vger.kernel.org

It's by far not that simple. Jani is working on both the underlying bug
and a better w/a. See

https://bugzilla.kernel.org/show_bug.cgi?id=59841

for the full story in its entire glory.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
