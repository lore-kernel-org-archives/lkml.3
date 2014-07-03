Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbaGCTsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 15:48:43 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:56301 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759020AbaGCTsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 15:48:42 -0400
Date: Thu, 3 Jul 2014 19:48:41 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, rnayak@ti.com, kishon@ti.com, george.cherian@ti.com,
        balbi@ti.com, balajitk@ti.com, nsekhar@ti.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ARM: DRA7: hwmod: Add OCP2SCP3 module
In-Reply-To: <1404385274-5093-2-git-send-email-rogerq@ti.com>
Message-ID: <alpine.DEB.2.02.1407031948110.1515@utopia.booyaka.com>
References: <1404385274-5093-1-git-send-email-rogerq@ti.com> <1404385274-5093-2-git-send-email-rogerq@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014, Roger Quadros wrote:

> This module is needed for the SATA and PCIe PHYs.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Reviewed-by: Rajendra Nayak <rnayak@ti.com>
> Tested-by: Sekhar Nori <nsekhar@ti.com>>

This looks like adding support for a new device, so, after 
discussing with Tony, queuing for v3.17.


- Paul
