Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbaDPV3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:29:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623AbaDPV3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:29:35 -0400
Date: Wed, 16 Apr 2014 23:29:32 +0200
From: Michal Marek <michal.marek@matfyz.cz>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v3] kbuild: move extra gcc checks to
 scripts/Makefile.extrawarn
Message-ID: <20140416212932.GC20810@fiji.localdomain>
References: <1397467630-16727-1-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397467630-16727-1-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 06:27:10PM +0900, Masahiro Yamada wrote:
> W=... provides extra gcc checks.
> 
> Having such code in scripts/Makefile.build results in the same flags
> being added to KBUILD_CFLAGS multiple times becuase
> scripts/Makefile.build is invoked every time Kbuild descends into
> the subdirectories.
> 
> Since the top Makefile is already too cluttered, this commit moves
> all of extra gcc check stuff to a new file scripts/Makefile.extrawarn,
> which is included from the top Makefile.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> Cc: Michal Marek <mmarek@suse.cz>
> CC: Sam Ravnborg <sam@ravnborg.org>
> ---
> 
> Changes in v3:
>   - Rebase on v3.15-rc1
>      (v2 caused a conflict with Clang stuff.)
> 
> Changes in v2:
>   - Move the code to a new file scripts/Makefile.extrawarn
>   - Move also "KBUILD_ENABLE_EXTRA_GCC_CHECKS" definition

Applied to kbuild.git#kbuild, thanks.

Michal
