Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3JZPSe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 11:18:34 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:38909 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751774Ab3JZPSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 11:18:33 -0400
Date: Sat, 26 Oct 2013 17:18:20 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org, linux@roeck-us.net,
        arnd@arndb.de
Subject: Re: [PATCH v8] watchdog: Add MOXA ART watchdog driver
Message-ID: <20131026151820.GA17243@spo001.leaseweb.com>
References: <1375101228-10930-1-git-send-email-jonas.jensen@gmail.com> <1375454445-15589-1-git-send-email-jonas.jensen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375454445-15589-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonas,

> This patch adds a watchdog driver for the main hardware watchdog timer
> found on MOXA ART SoCs.
> 
> The MOXA ART SoC provides one writable timer register, restarting
> the hardware once it reaches zero. The register is auto decremented
> every APB clock cycle.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Added to linux-watchdog-next.

Kind regards,
Wim.

