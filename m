Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab3C0Tvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:51:49 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57856 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab3C0Tvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:51:48 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 27 Mar 2013 12:52:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: linux-kernel@vger.kernel.org, Dom Cobley <popcornmix@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-rpi-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v4] watchdog: Add Broadcom BCM2835 watchdog timer driver
Message-ID: <20130327195201.GC11086@roeck-us.net>
References: <1364320200-23569-1-git-send-email-lkundrak@v3.sk>
 <1364402424-19503-1-git-send-email-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364402424-19503-1-git-send-email-lkundrak@v3.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 05:40:24PM +0100, Lubomir Rintel wrote:
> This adds a driver for watchdog timer hardware present on Broadcom BCM2835 SoC,
> used in Raspberry Pi and Roku 2 devices.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> Signed-off-by: Dom Cobley <popcornmix@gmail.com>
> Tested-by: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: Guenter Roeck <linux@roeck-us.net>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
