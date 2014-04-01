Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaDATQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 15:16:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41644 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaDATP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 15:15:59 -0400
Message-ID: <533B106B.8090408@infradead.org>
Date: Tue, 01 Apr 2014 12:15:55 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: linux-next: Tree for Apr 1 (drivers/gpu/drm/i915)
References: <20140401183907.a5127cadbe7116261096beaa@canb.auug.org.au>
In-Reply-To: <20140401183907.a5127cadbe7116261096beaa@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 12:39 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add material intended for v3.16 to your linux-next included
> branches until after v3.15-rc1 is released.
> 
> This tree still fails (more than usual) the powerpc allyesconfig build.
> 
> Changes since 20140331:
> 

for linux-next 0401 and 0331:

drivers/gpu/drm/i915/i915_cmd_parser.c:405:4: warning: format '%td' expects argument of type 'ptrdiff_t', but argument 5 has type 'long unsigned int' [-Wformat]


Just use %td without the (unsigned long) cast.


-- 
~Randy
