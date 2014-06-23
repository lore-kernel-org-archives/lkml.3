Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaFWE5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 00:57:33 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:51247 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaFWE5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 00:57:32 -0400
Date: Mon, 23 Jun 2014 04:57:31 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, rnayak@ti.com, nm@ti.com, kishon@ti.com,
        george.cherian@ti.com, balbi@ti.com, balajitk@ti.com, nsekhar@ti.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ARM: DRA7: hwmod: fixes for 3.16
In-Reply-To: <1403093816-10960-1-git-send-email-rogerq@ti.com>
Message-ID: <alpine.DEB.2.02.1406230450460.27636@utopia.booyaka.com>
References: <1403093816-10960-1-git-send-email-rogerq@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger

On Wed, 18 Jun 2014, Roger Quadros wrote:

> These patches add the missing OCP2SCP3 module and fixup the SATA hwmod
> for DRA7 SoC. Both patches are tested on 3.16-rc1.

Could you please post a quick serial capture of a boot log for these 
patches, as Felipe has done for other patches?

thanks,

- Paul
