Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab3GIWlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 18:41:35 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35531 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3GIWle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 18:41:34 -0400
Date: Tue, 9 Jul 2013 15:41:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Mika Kuoppala <mika.kuoppala@intel.com>
Subject: Re: [PATCH] Revert "drm/i915: unconditionally use mt forcewake on
 hsw/ivb"
Message-ID: <20130709224131.GA3097@roeck-us.net>
References: <1373400849-30351-1-git-send-email-linux@roeck-us.net>
 <20130709203322.GC18285@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709203322.GC18285@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 10:33:22PM +0200, Daniel Vetter wrote:
> On Tue, Jul 09, 2013 at 01:14:09PM -0700, Guenter Roeck wrote:
> > This reverts commit 36ec8f877481449bdfa072e6adf2060869e2b970.
> > 
> > The commit results in repeated 'Timed out waiting for forcewake old ack
> > to clear' messages on a Supermicro C7H61 board (BIOS version 2.00 and 2.00b)
> > with i7-3770K CPU. It ultimately results in a hangup if the system is highly
> > loaded. Reverting the commit fixes the issue.
> > 
> > While I understand that this should be fixed in the BIOS, a more recent BIOS
> > is not available fron the vendor. If/since no better solution is not available,
> > reverting the patch seems to be the way to go (otherwise me and others with
> > the same problem won't be able to run the upstream kernel on affected boards).
> > 
> > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Cc: Mika Kuoppala <mika.kuoppala@intel.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> 
> Can you please add the bugzilla link here?
> 
I'll create one and add a reference.

Thanks,
Guenter
