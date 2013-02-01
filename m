Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030178Ab3BALXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:23:17 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34608 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab3BALXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:23:12 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Philip Avinash <avinashphilip@ti.com>
Cc: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, vaibhav.bedia@ti.com,
        gururaja.hebbar@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: AM33XX: Corrects typo in interrupt field in SPI node
References: <1359697047-1816-1-git-send-email-avinashphilip@ti.com>
Date: Fri, 01 Feb 2013 12:23:05 +0100
In-Reply-To: <1359697047-1816-1-git-send-email-avinashphilip@ti.com> (Philip
	Avinash's message of "Fri, 1 Feb 2013 11:07:27 +0530")
Message-ID: <8738xg8ehy.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Philip" == Philip Avinash <avinashphilip@ti.com> writes:

 Philip> DT field of "interrupts" was mentioned wrongly as "interrupt" in SPI
 Philip> node. This went unnoticed as spi-omap2 driver not making use of
 Philip> interrupt. Fixes the typo.

 Philip> Signed-off-by: Philip Avinash <avinashphilip@ti.com>

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
