Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaJGOVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:21:23 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54394 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaJGOVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:21:22 -0400
Date: Tue, 7 Oct 2014 14:21:17 +0000
From: "Sylvain 'ythier' Hitier" <sylvain.hitier@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, nhorman@tuxdriver.com, mroos@linux.ee
Subject: Re: [PATCH v3] 3c59x: fix bad split of cpu_to_le32(pci_map_single())
Message-ID: <20141007142117.GD8838@erable>
References: <20140929210132.GD15737@erable>
 <20141001.163512.902486975602548782.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001.163512.902486975602548782.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When: 2014-10-01_3@16-35-12 -0400
Who:  David Miller
What:
> Networking patches need to be at least CC:'d to netdev@vger.kernel.org

Done with [PATCH RESEND v3].

I also added the maintainer (as resulted from ./scripts/get_maintainer.pl )
but this address is no longer valid: I got 550 SMTP error.


Regards,
Sylvain "ythier" Hitier

-- 
Business is about being busy, not being rich...
Lived 777 days in a Debian package => http://en.wikipedia.org/wiki/Apt,_Vaucluse
There's THE room for ideals in this mechanical place!
