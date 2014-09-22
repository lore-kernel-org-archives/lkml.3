Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaIVUGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:06:02 -0400
Received: from coloquinte.cristau.org ([91.121.16.100]:37965 "EHLO
	coloquinte.cristau.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbaIVUGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:06:00 -0400
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2014 16:06:00 EDT
Date: Mon, 22 Sep 2014 21:58:17 +0200
From: Julien Cristau <jcristau@debian.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, David Airlie <airlied@linux.ie>,
        dmarlin@redhat.com, Brian Paul <brianp@vmware.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] drm/vmwgfx: Fix drm.h include
Message-ID: <20140922195817.GV10640@betterave.cristau.org>
References: <20140905171959.GO5216@hansolo.jdub.homelinux.org>
 <CA+5PVA5t5Q3gRPaHebM7npfKLpET7xm70DXDWMbV0L0nsviBvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5t5Q3gRPaHebM7npfKLpET7xm70DXDWMbV0L0nsviBvQ@mail.gmail.com>
X-Operating-System: Linux 3.14-2-amd64 x86_64
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 09:43:50 -0400, Josh Boyer wrote:

> On Fri, Sep 5, 2014 at 1:19 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> > The userspace drm.h include doesn't prefix the drm directory.  This can lead
> > to compile failures as /usr/include/drm/ isn't in the standard gcc include
> > paths.  Fix it to be <drm/drm.h>, which matches the rest of the driver drm
> > header files that get installed into /usr/include/drm.
> >
> > Red Hat Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1138759
> >
> > Fixes: 1d7a5cbf8f74e
> > Reported-by: Jeffrey Bastian <jbastian@redhat.com>
> > Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> 
> Ping?  Did this get queued anywhere?
> 
Any reason this doesn't just #include "drm.h"?  That should work whether
the drm headers are installed in /usr/include/drm/ or
/usr/include/libdrm/...

Cheers,
Julien, who doesn't have a /usr/include/drm/ either
