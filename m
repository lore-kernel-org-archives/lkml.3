Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbaBLVGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:06:03 -0500
Received: from smtp.outflux.net ([198.145.64.163]:38553 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbaBLVGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:06:01 -0500
Date: Wed, 12 Feb 2014 13:05:54 -0800
From: Kees Cook <kees@outflux.net>
To: Dave Jones <davej@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: flaw in "nf_tables: add reject module for NFPROTO_INET"
Message-ID: <20140212210554.GM23300@outflux.net>
References: <52fb24097b42_6b5073486c727c3@209.249.196.67.mail>
 <20140212204307.GK23300@outflux.net>
 <20140212205037.GA6563@redhat.com>
 <20140212205453.GL23300@outflux.net>
 <20140212210347.GB6563@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212210347.GB6563@redhat.com>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 04:03:47PM -0500, Dave Jones wrote:
> I wonder if it's worth getting a coverity@vger.kernel.org list set up for
> cc'ing stuff like this to reduce dupe reports (though this is the first I
> recall in a while), and for review of patches etc before forwarding them on
> to their relevant list/maintainers.
> 
> thoughts?

I'd be up for it. It's why I CC'd you, I figured if I'd missed the
report it would have likely have come from you. :) Perhaps just start
by CCing each other, and if others want to get in on the fun too, move
to a list then?

-Kees

-- 
Kees Cook                                            @outflux.net
