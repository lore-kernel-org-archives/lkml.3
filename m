Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaLENxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:53:52 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:60011 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbaLENxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:53:50 -0500
Date: Fri, 5 Dec 2014 14:54:18 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Jike Song <jike.song@intel.com>, kvm@vger.kernel.org,
        "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Li, Susie" <susie.li@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        linux-kernel@vger.kernel.org, "Haron, Sandra" <sandra.haron@intel.com>
Subject: Re: [Intel-gfx] [ANNOUNCE][RFC] KVMGT - the implementation of Intel
 GVT-g(full GPU virtualization) for KVM
Message-ID: <20141205135418.GL20350@phenom.ffwll.local>
Mail-Followup-To: Gerd Hoffmann <kraxel@redhat.com>,
	Jike Song <jike.song@intel.com>, kvm@vger.kernel.org,
	"White, Michael L" <michael.l.white@intel.com>,
	"Dong, Eddie" <eddie.dong@intel.com>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"Li, Susie" <susie.li@intel.com>,
	"Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
	linux-kernel@vger.kernel.org,
	"Haron, Sandra" <sandra.haron@intel.com>
References: <547FC5DE.4010701@intel.com>
 <1417769421.11297.37.camel@nilsson.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417769421.11297.37.camel@nilsson.home.kraxel.org>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 09:50:21AM +0100, Gerd Hoffmann wrote:
> > 	https://www.usenix.org/conference/atc14/technical-sessions/presentation/tian
> 
> /me goes read this.
> 
> A few comments on the kernel stuff (brief look so far, also
> compile-tested only, intel gfx on my test machine is too old).
> 
>  * Noticed the kernel bits don't even compile when configured as
>    module.  Everything (vgt, i915, kvm) must be compiled into the
>    kernel.
>  * Design approach still seems to be i915 on vgt not the other way
>    around.

Yeah done a quick read-through of just the i915 bits too, same comment. I
guess this is just the first RFC and the redesign we've discussed about
already with xengt is in progress somewhere?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
