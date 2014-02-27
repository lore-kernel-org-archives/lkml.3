Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaB0NMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:12:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaB0NMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:12:50 -0500
Date: Thu, 27 Feb 2014 14:12:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>
cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: i915 resume-from-hibernation problems on resume with current
 Linus' tree
In-Reply-To: <alpine.LNX.2.00.1402271153480.21399@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1402271411130.21399@pobox.suse.cz>
References: <alpine.LNX.2.00.1402271153480.21399@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014, Jiri Kosina wrote:

> Hi,
> 
> first things first: this is hard to bisect, because it doesn't happen 
> reliably and I don't really know what is the first good version, as I had 
> a delay in following Linus' tree.

I think that I should've been clearer about the versions here -- I don't 
recall seeing this problem with 3.13, and I had trouble running early 3.14 
rcs because of 4e6b788c3f on this machine.

-- 
Jiri Kosina
SUSE Labs
