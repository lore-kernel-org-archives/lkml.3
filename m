Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3GHEya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 00:54:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43108 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752114Ab3GHEy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 00:54:29 -0400
Message-ID: <1373259267.1893.7.camel@joe-AO722>
Subject: Re: [v9fs:for-linus 7/7] ERROR: code indent should use tabs where
 possible
From: Joe Perches <joe@perches.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Jim Garlick <garlick@llnl.gov>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 07 Jul 2013 21:54:27 -0700
In-Reply-To: <20130708044542.GE20091@localhost>
References: <51d9c6c4.k6qhnvy45dNR8Ghq%fengguang.wu@intel.com>
	 <20130708004233.GA8958@localhost>
	 <CAFkjPTk5EZ_d5BdTTHjgrwdtU1XfZ3go_7ZDCv4Q_oqnn95AHg@mail.gmail.com>
	 <20130708033004.GA20091@localhost> <1373255644.1893.3.camel@joe-AO722>
	 <20130708044542.GE20091@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 12:45 +0800, Fengguang Wu wrote:
> On Sun, Jul 07, 2013 at 08:54:04PM -0700, Joe Perches wrote:
> > On Mon, 2013-07-08 at 11:30 +0800, Fengguang Wu wrote:
> > > In long run I'd like to disable
> > > the check types that tend to have false positives.  As for now, these
> > > checks are disabled in my checkpatch robot:
> > 
> > Are you using a .checkpatch.conf file?
> 
> Nope.
> 
> > > PATCH_PREFIX
> > > LONG_LINE
> > > CAMELCASE
> > 
> > That's a --strict test
> 
> Yes. The CAMELCASE checks are false positives for the USB subsystem.
> Where they followed the USB spec and use names like bInterfaceClass
> all over the places.

The latest version of checkpatch should avoid this.

> > > MISSING_SIGN_OFF
> > 
> > Why would you even consider this one?
> 
> It produces
> 
>         ERROR: Missing Signed-off-by: line(s)
> 
> on
>         commit: 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376 Linux 3.10

Well, clearly Linus should sign off on his own commits...

>         tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git master
>         commit: 97966e7ec944580bc3f46712f34ecb3c854fdd4b [37/81] Revert "ALSA: hda - Fix wrong power setup for HP paths of VIA codecs"
> 
>         tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git master
>         head:   120b1922175789a8a9bdafb7ea755fc63de2f392
>         commit: 10296279acc5d3caeca7b2cfde329c8280fe67e5 [32/81] Merge branch 'for-linus'
> 
> and many other commits

Not in -next as of today.

> > > TRAILING_STATEMENTS
> > False positives?  Got an example?
> tree:   git://git.freedesktop.org/git/nouveau/linux-2.6 drm-nouveau-next
> head:   d2989b534ef6834ebf2425aecc040b894b567c91
> commit: 01672ef454307bf63e93defb3599399b678ff58b [3/68] drm/nve0/fifo: copy engine context stored in ramfc, not externally
> 
> ERROR: trailing statements should be on next line
> #28: FILE: drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c:146:
> +       case NVDEV_ENGINE_GR   : addr = 0x0210; break;

Not false positives.


