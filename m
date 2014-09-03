Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbaICIeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:34:15 -0400
Received: from canardo.mork.no ([148.122.252.1]:35630 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbaICIeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:34:12 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Hayes Wang <hayeswang@realtek.com>
Cc: <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/2] r8152: use eth_hw_addr_random
Organization: m
References: <1394712342-15778-26-Taiwan-albertk@realtek.com>
	<1394712342-15778-29-Taiwan-albertk@realtek.com>
	<1394712342-15778-31-Taiwan-albertk@realtek.com>
Date: Wed, 03 Sep 2014 10:33:12 +0200
In-Reply-To: <1394712342-15778-31-Taiwan-albertk@realtek.com> (Hayes Wang's
	message of "Wed, 3 Sep 2014 10:59:15 +0800")
Message-ID: <87egvtyugn.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> writes:

> +		ether_addr_copy(dev->perm_addr, dev->dev_addr);

This isn't strictly necessary.  register_netdev() will do it for you as
long as you leave the default addr_assign_type (NET_ADDR_PERM).  And you
do.



Bjørn
