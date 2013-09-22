Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3IVVvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:51:13 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:40245 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3IVVvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:51:11 -0400
Date: Sun, 22 Sep 2013 17:51:07 -0400
From: Tejun Heo <tj@kernel.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Roger Quadros <rogerq@ti.com>, balbi@ti.com, bcousson@baylibre.com,
        tony@atomide.com, balajitk@ti.com, kishon@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH 08/15] ata: ahci_platform: Manage SATA PHY
Message-ID: <20130922215107.GD27616@mtj.dyndns.org>
References: <1379595943-14622-1-git-send-email-rogerq@ti.com>
 <1379595943-14622-9-git-send-email-rogerq@ti.com>
 <20130922165817.GD30946@htj.dyndns.org>
 <523F35E4.6050707@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523F35E4.6050707@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Sep 22, 2013 at 10:24:36PM +0400, Sergei Shtylyov wrote:
>    Not sure why you asked -- I'm not using this driver, neither I'm

Well, you have better grip of what's going on in the embedded world
than me.  I'm mostly curious whether adding dependency on PHY is okay.

Thanks.

-- 
tejun
