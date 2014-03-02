Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaCBOZu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 09:25:50 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:60359 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751995AbaCBOZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 09:25:48 -0500
Date: Sun, 2 Mar 2014 15:25:44 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] watchdog: orion: prepare new Dove DT Kconfig variable
Message-ID: <20140302142544.GU1484@spo001.leaseweb.com>
References: <1393536486-3827-3-git-send-email-sebastian.hesselbarth@gmail.com> <1393662801-17950-2-git-send-email-sebastian.hesselbarth@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393662801-17950-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

> DT-enabled Dove will move over from ARCH_DOVE in mach-dove to MACH_DOVE in
> mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
> DT-only MACH_DOVE Kconfig.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Acked-by: Wim Van Sebroeck <wim@iguana.be>

Patch added to linux-watchdog-next.

Kind regards,
Wim.

