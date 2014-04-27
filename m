Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaD0ReB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:34:01 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60354 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909AbaD0Rd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:33:58 -0400
X-Sasl-enc: 60ipgL/H4iG48MJovMYWX0fQXMUNnIpM9HHem1UkQzcd 1398620036
Date: Sun, 27 Apr 2014 10:34:40 -0700
From: Greg KH <greg@kroah.com>
To: Florian Kaiser <fk@florian-kaiser.net>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.10.y: backport b04c46190219a4f845e46a459e3102137b7f6cac
Message-ID: <20140427173440.GA11217@kroah.com>
References: <535D3AA8.5030306@florian-kaiser.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535D3AA8.5030306@florian-kaiser.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 07:13:12PM +0200, Florian Kaiser wrote:
> Hello,
> 
> Not sure if you did not include this for a reason in the latest 3.10.y
> (3.10.38, released 16 hours ago) or if you just missed it. In the latter case,
> please backport it.
> 
> Patch from commit b04c46190219a4f845e46a459e3102137b7f6cac should apply with
> some offsets but otherwise work as expected. We tested with 3.10.37 and did
> not find any regressions or other unexpected behavior.
> 
> As for now, 3.10.y LTS would still be vulnerable to CVE-2014-2851.

I take networking patches from the networking maintainer, and don't
apply them on my own.  So please ask about this on the netdev list,
after checking that the netdev stable patchwork queue doesn't already
have the patch in it (sorry, I don't have the link to that at the
moment...)

thanks,

greg k-h
