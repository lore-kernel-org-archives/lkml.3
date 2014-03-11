Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbaCKTtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:49:14 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:47951 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbaCKTtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:49:12 -0400
Date: Tue, 11 Mar 2014 12:49:19 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        ARM Maintainers <arm@kernel.org>, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: Re: [PATCH for 3.14] ARM: at91: fix network interface ordering for
 sama5d36
Message-ID: <20140311194919.GB31877@quad.lixom.net>
References: <1394462238-22313-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394462238-22313-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 03:37:18PM +0100, Nicolas Ferre wrote:
> From: Boris BREZILLON <b.brezillon.dev@gmail.com>
> 
> On the newly introduced sama5d36, Gigabit and 10/100 Ethernet network
> interfaces are probed in a different order than for the sama5d35.
> Moreover, users are accustomed to this order in bootloaders and backports
> for older kernel revisions.
> So this patch switches DT node order as it is done for the other dual-Ethernet
> sama5d3 SoC.
> Better interface numbering which does not depend on DT node order is being
> developed for stronger interface identification.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Olof, Arnd and Kevin,
> 
> I would like to include this fix in 3.14-final.
> I do not have anymore patch for an at91-3.14-fixes branch so I only send this
> single patch to you. Can you still take it?

Sure, applied now.


-Olof
