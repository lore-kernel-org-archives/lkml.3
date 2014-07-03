Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbaGCTsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 15:48:12 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:56234 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbaGCTsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 15:48:09 -0400
Date: Thu, 3 Jul 2014 19:48:08 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, rnayak@ti.com, kishon@ti.com, george.cherian@ti.com,
        balbi@ti.com, balajitk@ti.com, nsekhar@ti.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ARM: DRA7: hwmod: Add SYSCONFIG for usb_otg_ss
In-Reply-To: <1404385274-5093-4-git-send-email-rogerq@ti.com>
Message-ID: <alpine.DEB.2.02.1407031948020.1515@utopia.booyaka.com>
References: <1404385274-5093-1-git-send-email-rogerq@ti.com> <1404385274-5093-4-git-send-email-rogerq@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014, Roger Quadros wrote:

> Add the sysconfig class bits for the Super Speed USB
> controllers
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Reviewed-by: Rajendra Nayak <rnayak@ti.com>
> Tested-by: Sekhar Nori <nsekhar@ti.com>

Thanks, this looks like a fix, so, queueing for v3.16-rc.


- Paul
