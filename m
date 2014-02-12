Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaBLVlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:41:23 -0500
Received: from smtp.outflux.net ([198.145.64.163]:59258 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbaBLVlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:41:22 -0500
Date: Wed, 12 Feb 2014 13:41:12 -0800
From: Kees Cook <kees@outflux.net>
To: tytso@mit.edu, Dave Jones <davej@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: flaw in "nf_tables: add reject module for NFPROTO_INET"
Message-ID: <20140212214112.GN23300@outflux.net>
References: <52fb24097b42_6b5073486c727c3@209.249.196.67.mail>
 <20140212204307.GK23300@outflux.net>
 <20140212205037.GA6563@redhat.com>
 <20140212205453.GL23300@outflux.net>
 <20140212210347.GB6563@redhat.com>
 <20140212210554.GM23300@outflux.net>
 <20140212213151.GB12617@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212213151.GB12617@thunk.org>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 09:31:51PM +0000, tytso@mit.edu wrote:
> I'm paying attention to Linux kernel coverity reports (as well as
> working on my goal to drive the number of e2fsprogs coverity reports
> to zero :-), so feel free to CC me on any reports.

Okay, 3 people sounds like "we need a mailing list". :) Who's best to
ask for that?

-Kees

-- 
Kees Cook                                            @outflux.net
