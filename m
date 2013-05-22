Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3EVSZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:25:00 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:40906 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab3EVSY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:24:58 -0400
Date: Wed, 22 May 2013 12:24:48 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        "tiejun.chen" <tiejun.chen@windriver.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH v4 06/12] ARM: dove: add gigabit ethernet and mvmdio
 device tree nodes
Message-ID: <20130522182448.GA17206@obsidianresearch.com>
References: <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369154510-4927-7-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130521174849.GL26249@lunn.ch>
 <519C9333.20609@gmail.com>
 <519C9822.9040909@windriver.com>
 <519C9A66.3050807@gmail.com>
 <20130522131010.GB31290@titan.lakedaemon.net>
 <20130522165908.GB12320@obsidianresearch.com>
 <519D0143.1000203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519D0143.1000203@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 07:32:51PM +0200, Sebastian Hesselbarth wrote:
 
> Not neccessary anyway, after talking Jason C in a Kirkwood-only
> workaround I prepared a patch that reads mac address registers early
> and stores it in the local-mac-address property.

That sounds great, but, FWIW, our bootloaders don't set the MAC
address registers. Does the work around only trigger if the
local-mac-address property is 0?

Jason
