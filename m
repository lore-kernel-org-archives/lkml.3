Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaLHIl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:41:58 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51828 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbaLHIl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:41:56 -0500
Date: Mon, 8 Dec 2014 09:42:28 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] gpu: drm: i915: intel_display.c:  Remove unused function
Message-ID: <20141208084228.GI20350@phenom.ffwll.local>
Mail-Followup-To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <1417976957-15049-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417976957-15049-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2014 at 07:29:17PM +0100, Rickard Strandqvist wrote:
> Remove the function intel_output_name() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Queued for 3.20, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
