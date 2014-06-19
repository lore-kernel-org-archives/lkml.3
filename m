Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbaFSFsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 01:48:37 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:44172 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaFSFsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 01:48:36 -0400
Date: Thu, 19 Jun 2014 05:48:35 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, rnayak@ti.com, nm@ti.com, kishon@ti.com,
        george.cherian@ti.com, balbi@ti.com, balajitk@ti.com, nsekhar@ti.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: DRA7: hwmod: Add OCP2SCP3 module
In-Reply-To: <1403093816-10960-2-git-send-email-rogerq@ti.com>
Message-ID: <alpine.DEB.2.02.1406190546520.13869@utopia.booyaka.com>
References: <1403093816-10960-1-git-send-email-rogerq@ti.com> <1403093816-10960-2-git-send-email-rogerq@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Roger Quadros wrote:

> This module is needed for the SATA and PCIe PHYs.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Tested-by: Roger Quadros <rogerq@ti.com>

Is this one a fix?  It looks to me like a new IP block addition.


- Paul
