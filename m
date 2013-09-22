Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3IVQ6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 12:58:23 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:42627 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab3IVQ6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 12:58:21 -0400
Date: Sun, 22 Sep 2013 12:58:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, bcousson@baylibre.com, tony@atomide.com, balajitk@ti.com,
        kishon@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [RFC PATCH 08/15] ata: ahci_platform: Manage SATA PHY
Message-ID: <20130922165817.GD30946@htj.dyndns.org>
References: <1379595943-14622-1-git-send-email-rogerq@ti.com>
 <1379595943-14622-9-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379595943-14622-9-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 04:05:36PM +0300, Roger Quadros wrote:
> From: Balaji T K <balajitk@ti.com>
> 
> Some platforms have a PHY hooked up to the
> SATA controller. The PHY needs to be initialized
> and powered up for SATA to work. We do that
> using the PHY framework.
> 
> [Roger Q] Cleaned up.
> 
> CC: Tejun Heo <tj@kernel.org>
> Signed-off-by: Balaji T K <balajitk@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Looks okay to me although I don't know whether everyone using
ahci_platform would be happy with requiring phy.  Sergei, does this
look good to you?

Thanks.

-- 
tejun
