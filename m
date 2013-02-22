Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab3BVKUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:20:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab3BVKUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:20:40 -0500
Date: Fri, 22 Feb 2013 11:20:38 +0100
From: Michal Marek <mmarek@suse.cz>
To: Bin Wang <wbin00@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scripts/package/Makefile: remove useless
	KBUILD_OUTPUT test
Message-ID: <20130222102038.GC12402@pobox.suse.cz>
References: <1358753285-11812-1-git-send-email-wbin00@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358753285-11812-1-git-send-email-wbin00@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 03:28:05PM +0800, Bin Wang wrote:
> The test of KBUILD_OUTPUT in "rpm-pkg rpm" target is useless.
> KBUILD_OUTPUT is always empty here.

Right, but the error message is valid, make rpm-pkg does not work with
O=. So I suggest to either fix make O=... rpm-pkg, or fix the test to
compare $(srctree) and $(objtree) instead.

Michal
