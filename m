Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaGGIjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:39:01 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54647 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaGGIi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:38:59 -0400
Date: Mon, 7 Jul 2014 10:39:08 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: 3.15-rc: regression in suspend
Message-ID: <20140707083908.GE5821@phenom.ffwll.local>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>,
	Pavel Machek <pavel@ucw.cz>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Linux-pm mailing list <linux-pm@lists.osdl.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	intel-gfx <intel-gfx@lists.freedesktop.org>
References: <20140514182046.GA13342@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1405151727380.16459@pobox.suse.cz>
 <CAKMK7uFEjDGSpdB0xDPL09GZ8N7aFrNA530HbRLyfTPx5SkLQw@mail.gmail.com>
 <20140607120614.GB5309@amd.pavel.ucw.cz>
 <20140607231124.GA3611@amd.pavel.ucw.cz>
 <CAKMK7uEALofLiEA3m-QKjygC=YZNjaEtUMfbpbXinMoim1ygkw@mail.gmail.com>
 <20140609102328.GA25332@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1406091302560.20782@pobox.suse.cz>
 <20140625223522.GA5923@xo-6d-61-c0.localdomain>
 <alpine.LNX.2.00.1406271537000.21386@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1406271537000.21386@pobox.suse.cz>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 03:37:16PM +0200, Jiri Kosina wrote:
> On Thu, 26 Jun 2014, Pavel Machek wrote:
> 
> > Ok, so I have set up machines for ktest / autobisect, and found out that 
> > 3.16-rc1 no longer has that problem. Oh well, bisect would not be fun, 
> > anyway...
> 
> I am still seeing the problem with 3.16-rc2.

I'm confused now. Is the bisect result

commit 773875bfb6737982903c42d1ee88cf60af80089c
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon Jan 27 10:00:30 2014 +0100

    drm/i915: Don't set the 8to6 dither flag when not scaling

now the culprit or not? Or do we have 2 different bugs at hand here?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
