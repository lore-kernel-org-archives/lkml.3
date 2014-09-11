Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbaIKMWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:22:23 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:50048 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaIKMWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:22:21 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Thu, 11 Sep 2014 08:22:19 -0400
To: Mugunthan V N <mugunthanvnm@ti.com>
Cc: bcousson@baylibre.com, tony@atomide.com, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ARM: dts: dra7: Add CPSW and MDIO module nodes
 for dra7
Message-ID: <20140911122219.GD17690@csclub.uwaterloo.ca>
References: <1410356247-25925-1-git-send-email-mugunthanvnm@ti.com>
 <1410356247-25925-2-git-send-email-mugunthanvnm@ti.com>
 <20140911013811.GB17692@csclub.uwaterloo.ca>
 <541141E3.8030101@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541141E3.8030101@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 12:02:03PM +0530, Mugunthan V N wrote:
> slaves = <1>;

OK, works for me.

> overall disable takes care of this

Although once I enable cpsw I would need to leave the second port disabled
I suppose, although perhaps settings slaves to 1 would essentially
disable it.

> Will add disabled in next version.

-- 
Len Sorensen
