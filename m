Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3EPHtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:49:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849Ab3EPHtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:49:49 -0400
Date: Thu, 16 May 2013 09:49:47 +0200
From: Michal Marek <mmarek@suse.cz>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] package: Makefile: unbreak binrpm-pkg target
Message-ID: <20130516074947.GA19300@sepie.suse.cz>
References: <20130515120626.70a160aa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515120626.70a160aa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 12:06:26PM -0400, Luiz Capitulino wrote:
> Commit 6501320311664e11ad5489fedb17ea1f817c2617 dropped the rpm spec as a
> prerequisite for the binrpm-pkg target but forgot to update $< usage,
> which causes the rule to break.

Oops :)


> This commit fixes that by replacing $< with the spec name.

Thanks for the fix, I added it to kbuild.git#rc-fixes.

Michal
