Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab3IVVtG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:49:06 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:33047 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3IVVtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:49:03 -0400
Date: Sun, 22 Sep 2013 17:48:59 -0400
From: Tejun Heo <tj@kernel.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Roger Quadros <rogerq@ti.com>, balbi@ti.com, bcousson@baylibre.com,
        tony@atomide.com, balajitk@ti.com, kishon@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH 08/15] ata: ahci_platform: Manage SATA PHY
Message-ID: <20130922214859.GC27616@mtj.dyndns.org>
References: <1379595943-14622-1-git-send-email-rogerq@ti.com>
 <1379595943-14622-9-git-send-email-rogerq@ti.com>
 <523F3567.80303@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523F3567.80303@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Sep 22, 2013 at 10:22:31PM +0400, Sergei Shtylyov wrote:
> >@@ -37,6 +37,7 @@
> >
> >  #include <linux/clk.h>
> >  #include <linux/libata.h>
> >+#include <linux/phy/phy.h>
> 
> struct phy;
> 
> should suffice.

Unless it's actually likely to cause inclusion loop, I think it's
better to include the header than adding explicit declarations.

Thanks.

-- 
tejun
