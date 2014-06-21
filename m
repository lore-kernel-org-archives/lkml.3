Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbaFUVHI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:07:08 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:63060 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754410AbaFUVHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:07:07 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Sat, 21 Jun 2014 22:06:52 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: 3.16, i915: less colors in X?
Message-ID: <20140621210652.GA14025@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Pavel Machek <pavel@ucw.cz>, Daniel Vetter <daniel.vetter@ffwll.ch>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>
References: <20140514155759.GB9723@amd.pavel.ucw.cz>
 <20140514182046.GA13342@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1405151727380.16459@pobox.suse.cz>
 <CAKMK7uFEjDGSpdB0xDPL09GZ8N7aFrNA530HbRLyfTPx5SkLQw@mail.gmail.com>
 <20140607120614.GB5309@amd.pavel.ucw.cz>
 <20140607231124.GA3611@amd.pavel.ucw.cz>
 <CAKMK7uEALofLiEA3m-QKjygC=YZNjaEtUMfbpbXinMoim1ygkw@mail.gmail.com>
 <20140609102328.GA25332@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1406091302560.20782@pobox.suse.cz>
 <20140621202901.GA3840@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140621202901.GA3840@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 10:29:01PM +0200, Pavel Machek wrote:
> Hi!
> 
> I just test-booted 3.16-rc1, and background in X looked just wrong --
> very noticeable bands on the background gradient. I thought that maybe
> it is just my eyes, but I went back to older kernel, and background is
> ok now.
> 
> I'm trying to figure out how to ask X what color depth it is using...?
> 
> This is thinkpad x60 with Debian 6.0.9.
> 
> Any ideas?

That suggests that the panel dithering changed. Compare intel_reg_dumper
output for both kernels, especially PIPE.CONF.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
