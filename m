Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbaDBKpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 06:45:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758150AbaDBKpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 06:45:51 -0400
Date: Wed, 2 Apr 2014 12:45:17 +0200
From: chrubis@suse.cz
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Richard Hansen <rhansen@bbn.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Greg Troxel <gdt@ir.bbn.com>
Subject: Re: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC
Message-ID: <20140402104517.GA20656@rei>
References: <533B04A9.6090405@bbn.com>
 <533B1439.3010403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533B1439.3010403@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > and there's no good
> > reason to believe that this behavior would have persisted
> > indefinitely.
> > 
> > The msync(2) man page (as currently written in man-pages.git) is
> > silent on the behavior if both flags are unset, so this change should
> > not break an application written by somone who carefully reads the
> > Linux man pages or the POSIX spec.
> 
> Sadly, people do not always carefully read man pages, so there
> remains the chance that a change like this will break applications.
> Aside from standards conformance, what do you see as the benefit
> of the change?

I've looked around Linux Test Project and this change will break a few
testcases, but nothing that couldn't be easily fixed.

The rest of the world may be more problematic though.

-- 
Cyril Hrubis
chrubis@suse.cz
