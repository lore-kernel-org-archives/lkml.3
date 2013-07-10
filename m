Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab3GJMZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:25:26 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:49939 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab3GJMZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:25:25 -0400
Date: Wed, 10 Jul 2013 14:25:23 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Subject: Re: [GIT] Networking
Message-ID: <20130710122523.GA357@x4>
References: <20130709.145325.1363244885668360965.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709.145325.1363244885668360965.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.07.09 at 14:53 -0700, David Miller wrote:
> 
> Alexey Brodkin (2):
>       ethernet/arc/arc_emac - Add new driver
>       arc_emac: fix compile-time errors & warnings on PPC64

This driver defaults to y for no reason:

+config NET_VENDOR_ARC
+       bool "ARC devices"
+       default y

-- 
Markus
