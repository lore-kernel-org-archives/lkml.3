Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab3JXHIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:08:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab3JXHIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:08:15 -0400
Date: Thu, 24 Oct 2013 08:08:10 +0100 (BST)
From: Jiri Kosina <jkosina@suse.cz>
To: Egbert Eich <eich@suse.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Egbert Eich <eich@suse.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: HPD flood warning since b8f102e8b
In-Reply-To: <21093.23168.424554.698941@linux-qknr.site>
Message-ID: <alpine.LNX.2.00.1310240806370.30926@pobox.suse.cz>
References: <alpine.LNX.2.00.1310031141260.29701@pobox.suse.cz> <CAKMK7uEbGZ3_tHTCqOT7H4eViBnYmkPTS210jOvfweSf3gQ_fg@mail.gmail.com> <alpine.LNX.2.00.1310031632320.29701@pobox.suse.cz> <21093.23168.424554.698941@linux-qknr.site>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Oct 2013, Egbert Eich wrote:

>  > On Thu, 3 Oct 2013, Daniel Vetter wrote:
>  > 
>  > > Can you please attach full dmesg from boot up to the first WARN with
>  > > drm.debug=0xe? This really shouldn't happen and indicates a bug
>  > > somewhere ...
>  > 
>  > A bit difficult ... I originally thought that it was reliably 
>  > reproducible, but now I didn't get it after 10 suspend/resume cycles. Will 
>  > keep following it, and once it appears, will send you the dmesg.
>  > 
> Could you check if you get any messages regarding HPD storms after 
> suspend/resume ie messages like:
> "[drm] HPD interrupt storm detected on connector HDMI-A-1"
> but without the annouing warn messages?

I have this:

[357128.184113] [drm] HPD interrupt storm detected on connector DP-3: switching from hotplug detection to polling

It appeared in the log approximately 5 seconds after resume has been 
completed.

Thanks,

-- 
Jiri Kosina
SUSE Labs
