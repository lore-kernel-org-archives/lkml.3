Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271Ab3GaPVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:21:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736Ab3GaPVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:21:35 -0400
Date: Wed, 31 Jul 2013 16:21:31 +0100
From: Mel Gorman <mgorman@suse.de>
To: Tony Lindgren <tony@atomide.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] [ARM ATTEND] kernel data bloat
 and how to avoid it
Message-ID: <20130731152131.GW2296@suse.de>
References: <20130731073802.GT7656@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130731073802.GT7656@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 12:38:03AM -0700, Tony Lindgren wrote:
> Hi all,
> 
> Probably the biggest kernel data bloat issue is in the ARM land, but
> it also seems that it's becoming a Linux generic issue too, so I
> guess it could be discussed in either context.
> 

Would scripts/bloat-o-meter highlight where the growth problems are?

-- 
Mel Gorman
SUSE Labs
