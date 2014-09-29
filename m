Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbaI2TpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:45:24 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38890 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaI2TpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:45:22 -0400
Date: Mon, 29 Sep 2014 19:45:12 +0000
From: "Sylvain 'ythier' Hitier" <sylvain.hitier@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: nhorman@tuxdriver.com, linux-kernel@vger.kernel.org, mroos@linux.ee
Subject: Re: [PATCH v2] 3c59x: fix bad split of cpu_to_le32(pci_map_single())
Message-ID: <20140929194512.GB15737@erable>
References: <20140924093021.GA7929@erable>
 <20140924101647.GA4651@hmsreliant.think-freely.org>
 <20140925151519.GA12225@erable>
 <20140929.153748.2020820992295588670.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929.153748.2020820992295588670.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When: 2014-09-29_1@15-37-48 -0400
Who:  David Miller
What:
> Can someone please clean this up and submit it properly?

I'm willing to do it, but...
could you elaborate on "clean up" and "properly"?

Would it be OK for me re-sending my part as v3 including Neil's ack?
Or are you expecting a unique patch combining Neil's changes and mine?

Regards,
Sylvain "ythier" Hitier

-- 
Business is about being busy, not being rich...
Lived 777 days in a Debian package => http://en.wikipedia.org/wiki/Apt,_Vaucluse
There's THE room for ideals in this mechanical place!
