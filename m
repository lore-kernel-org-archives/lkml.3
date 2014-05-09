Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbaEIU6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:58:32 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:36342 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756796AbaEIU6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:58:30 -0400
Date: Fri, 9 May 2014 22:58:27 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: atx@atx.name
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH] rtc: Add support for Microchip MCP795
Message-ID: <20140509225827.55e395cd@linux.lan.towertech.it>
In-Reply-To: <20140506171318.GA2397@dashie>
References: <20140506171318.GA2397@dashie>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014 19:13:18 +0200
atx@atx.name wrote:

> Adds driver for SPI RTC Microchip MCP795. Does only support saving/loading time from the chip (i. e. no alarms/power events/ID).
> 
> Signed-off-by: Josef Gajdusek <atx@atx.name>

 
 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

