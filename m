Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbaLVOIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:08:15 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:50088 "EHLO
	spo001.leaseweb.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754768AbaLVOIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:08:14 -0500
Date: Mon, 22 Dec 2014 15:08:12 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 22/28] watchdog: drop owner assignment from platform_drivers
Message-ID: <20141222140812.GD27760@spo001.leaseweb.nl>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de> <1419196495-9626-23-git-send-email-wsa@the-dreams.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419196495-9626-23-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

> This platform_driver does not need to set an owner, it will be populated by the
> driver core.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Added to linux-watchdog-next.

Kind regards,
Wim.

