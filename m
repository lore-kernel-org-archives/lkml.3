Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946730Ab3BHQak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 11:30:40 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57468 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946518Ab3BHQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 11:30:38 -0500
Date: Fri, 8 Feb 2013 11:19:19 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: netdev <netdev@vger.kernel.org>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath9k-devel@venema.h4ckr.net, wil6210@qca.qualcomm.com,
        brcm80211-dev-list@broadcom.com,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] drivers: net: Remove remaining alloc/OOM messages
Message-ID: <20130208161918.GD2116@tuxdriver.com>
References: <1360273587.27863.15.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360273587.27863.15.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 01:46:27PM -0800, Joe Perches wrote:
> alloc failures already get standardized OOM
> messages and a dump_stack.
> 
> For the affected mallocs around these OOM messages:
> 
> Converted kmallocs with multiplies to kmalloc_array.
> Converted a kmalloc/memcpy to kmemdup.
> Removed now unused stack variables.
> Removed unnecessary parentheses.
> Neatened alignment.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

No objection...

Acked-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
