Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbaDPVIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:08:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561AbaDPVI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:08:29 -0400
Date: Wed, 16 Apr 2014 23:08:26 +0200
From: Michal Marek <michal.marek@matfyz.cz>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH] .gitignore: ignore Module.symvers in all directories
Message-ID: <20140416210826.GA20810@fiji.localdomain>
References: <415f152dbdb6d675ebca57afd8bfbc785a70cfd1.1397458539.git.gamerh2o@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <415f152dbdb6d675ebca57afd8bfbc785a70cfd1.1397458539.git.gamerh2o@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 02:56:15PM +0800, Zhao, Gang wrote:
> When using `make M=/path/to/driver modules` to build a module, file
> Module.symvers will be created in that directory, so it's better to
> ignore it in all directories.
> 
> Slightly reordered, let specific file names behind general ones.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kyungsik Lee <kyungsik.lee@lge.com>
> Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
> Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>

Note that the easier way to build a subtree of the kernel source is

  make path/to/driver/

including the trailing /. But the M=... syntax seems so widespread that
I have to apply this.

BTW: there is really no need to CC the last N people who touched
such a trivial file :).

Michal
