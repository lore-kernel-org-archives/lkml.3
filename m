Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3JKKZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:25:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab3JKKZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:25:40 -0400
Date: Fri, 11 Oct 2013 12:25:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Egbert Eich <eich@suse.de>, Jani Nikula <jani.nikula@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: HPD flood warning since b8f102e8b
In-Reply-To: <CAKMK7uEbGZ3_tHTCqOT7H4eViBnYmkPTS210jOvfweSf3gQ_fg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1310111224500.13289@pobox.suse.cz>
References: <alpine.LNX.2.00.1310031141260.29701@pobox.suse.cz> <CAKMK7uEbGZ3_tHTCqOT7H4eViBnYmkPTS210jOvfweSf3gQ_fg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Oct 2013, Daniel Vetter wrote:

> Can you please attach full dmesg from boot up to the first WARN with
> drm.debug=0xe? This really shouldn't happen and indicates a bug
> somewhere ...

OK, I haven't been able to reproduce this any more for ~week ... so please 
disregard this, and I'll report back if it comes back (will be running 
with full drm debug output for some time).

-- 
Jiri Kosina
SUSE Labs
