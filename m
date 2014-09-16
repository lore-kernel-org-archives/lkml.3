Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbaIPT55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:57:57 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59314 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755262AbaIPT5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:57:55 -0400
Date: Tue, 16 Sep 2014 20:57:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] arm: Convert pr_warning to pr_warn
Message-ID: <20140916195737.GO12361@n2100.arm.linux.org.uk>
References: <cover.1410632834.git.joe@perches.com> <7995478e8c658478cd37dabb996f7269405251ac.1410632835.git.joe@perches.com> <20140915155656.GA29744@arm.com> <20140916160759.GJ12361@n2100.arm.linux.org.uk> <1410884281.16519.2.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410884281.16519.2.camel@joe-AO725>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 09:18:01AM -0700, Joe Perches wrote:
> On Tue, 2014-09-16 at 17:07 +0100, Russell King - ARM Linux wrote:
> > any chance you could add a KernelVersion: tag somewhere in the
> > commit message and throw it at patches@arm.linux.org.uk so it doesn't
> > get lost?
> 
> There are no commit logs with a KernelVersion: tag
> in all of git history.

Right, that's not it's purpose.

> What do you think a KernelVersion: tag is and what
> would it be used for?

It's for that email address to know which kernel version the patch
was generated against, which is useful information when I come to
apply it.  It gets filtered out from the commit message.  It can go
anywhere, even below the -- line.

If you don't want to cooperate, you will have to rely on my notoriously
bad email skills to scan the mailing list for random patches to apply
some time (maybe days or even weeks) later after you send your message.
Which just won't happen.  It's why I wrote scripts which are some 20
years old to solve my bad email patch handling skills.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
