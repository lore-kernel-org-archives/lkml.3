Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3GQKBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 06:01:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48655 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752775Ab3GQKBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 06:01:39 -0400
Message-ID: <1374055298.1949.87.camel@joe-AO722>
Subject: Re: [drm-intel:drm-intel-fixes 52/52] ERROR: Unrecognized email
 address: 'stable.]'
From: Joe Perches <joe@perches.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, kbuild-all@01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Date: Wed, 17 Jul 2013 03:01:38 -0700
In-Reply-To: <CAKMK7uEPs-J+vmbc9rqw1FdV2mWucs1EyBB5NBeuqFZU0zz8Qw@mail.gmail.com>
References: <51e63ed0.zKgIdwWoDkYbRWqH%fengguang.wu@intel.com>
	 <20130717091028.GA31187@localhost>
	 <CAKMK7uEPs-J+vmbc9rqw1FdV2mWucs1EyBB5NBeuqFZU0zz8Qw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 11:29 +0200, Daniel Vetter wrote:
> On Wed, Jul 17, 2013 at 11:10 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > FYI, there are new warnings show up in
> > tree:   git://people.freedesktop.org/~danvet/drm-intel.git drm-intel-fixes
> > head:   71e4092e52499ec74bc1dec0f883b15f2c424ec5
> > commit: 71e4092e52499ec74bc1dec0f883b15f2c424ec5 [52/52] drm/i915: fix long-standing SNB regression in power consumption after resume v2
> >
> > scripts/checkpatch.pl 0001-drm-i915-fix-long-standing-SNB-regression-in-power-c.patch
> >
> > ERROR: Unrecognized email address: 'stable.]'
> > #41:
> > cc: stable.]
> 
> Well, I've added that while applying the patch - I tend to smash
> maintainer notes into the sob section and word-wraping caused the cc:
> stable remark to be parsed. Is there an officially sanctioned way for
> such notes that appeases checkpatch? Adding lkml and checkpatch
> maintainer.
> -Daniel

(It would have been nice to get the content that failes
 instead of having to pull the tree)

Don't wrap text to start a line with cc:

    Cc: Chris Wilson <chris@chris-wilson.co.uk>
    Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
    [danvet: Add note about v1 vs. v2 of this patch and use standard
    layout for the commit citation. Also add the tested-bys from v1 and a
    cc: stable.]
    Cc: stable@vger.kernel.org (Note: tiny conflict due to the addition of

You could have added something like:

    [danvet: Add note about v1 vs. v2 of this patch and use standard
             layout for the commit citation.
             Also add the tested-bys from v1 and a cc: stable.]


