Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab3CRXyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:54:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab3CRXyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:54:31 -0400
Date: Mon, 18 Mar 2013 20:54:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] ir: IR_RX51 only works on OMAP2
Message-ID: <20130318205403.4203e2fe@redhat.com>
In-Reply-To: <1363298204-8014-7-git-send-email-arnd@arndb.de>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
	<1363298204-8014-7-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 14 Mar 2013 22:56:44 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> This driver can be enabled on OMAP1 at the moment, which breaks
> allyesconfig for that platform. Let's mark it OMAP2PLUS-only
> in Kconfig, since that is the only thing it builds on.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: linux-media@vger.kernel.org
> ---
> Mauro, please apply for 3.9

OK, I'm applying it on my 3.9 branch right now.

Thanks!
Mauro
