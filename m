Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab3JIOV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:21:29 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57338 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752198Ab3JIOV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:21:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Lh+rKrr5YfUQjpsG4s++5w92aSOAphtE=
Date: Wed, 9 Oct 2013 10:21:25 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the mvebu tree
Message-ID: <20131009142125.GC5402@titan.lakedaemon.net>
References: <1381328067-1593-1-git-send-email-treding@nvidia.com>
 <1381328067-1593-6-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381328067-1593-6-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 04:14:27PM +0200, Thierry Reding wrote:
> Today's linux-next merge of the mvebu tree got conflicts in
> 
> 	arch/arm/mach-dove/board-dt.c
> 	arch/arm/mach-kirkwood/board-dt.c
> 
> caused by commits ebd7d3a (ARM: kirkwood: retain MAC address for DT
> ethernet), 511aaab (ARM: kirkwood: Remove unneeded MBus initialization)
> and a169e3a (ARM: kirkwood: remove custom .init_time hook) as well as
> ccbd35c (ARM: dove: remove legacy pcie and clock init), e5901b5 (ARM:
> dove: switch to DT probed mbus address windows) and 51e40f5 (ARM: dove:
> remove custom .init_time hook).
> 
> I fixed them up (see below). Please verify that the resolution looks
> good.

Looks good to me, thanks for picking up the linux-next duties, it's a
big help.

thx,

Jason.
