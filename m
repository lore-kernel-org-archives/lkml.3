Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaHQOIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 10:08:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaHQOIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 10:08:31 -0400
Date: Sun, 17 Aug 2014 16:08:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: Dave Airlie <airlied@gmail.com>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL] drm-intel-fixes
In-Reply-To: <20140808143418.GA25720@phenom.ffwll.local>
Message-ID: <alpine.LRH.2.00.1408171605170.29877@twin.jikos.cz>
References: <20140808143418.GA25720@phenom.ffwll.local>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014, Daniel Vetter wrote:

> Big fix is the duct-tape for ring init on g4x platforms, we seem to have
> found the magic again to make those machines as happy as before (not
> perfect though unfortunately, but that was never the case).

I unfortunately don't agree with the last part; there are older kernels 
(such as 3.7) where I have never ever seen this ring initialization 
failure, despite it being excercised very heavily (hundreds of 
suspend/resume cycles on the machine I am debugging this problem on).

As I said in the bugzilla already, the affected machine will be physically 
present in my bag at the Kernel Summit, in case it helps you guys from 
Intel to debug it.

-- 
Jiri Kosina
SUSE Labs

