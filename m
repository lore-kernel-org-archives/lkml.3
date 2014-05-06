Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934734AbaEFJzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:55:04 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:55448 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934558AbaEFJzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:55:01 -0400
Date: Tue, 6 May 2014 11:54:58 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: macro@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH 1/2] RTC: rtc-cmos: drivers/char/rtc.c
 features for DECstation support
Message-ID: <20140506115458.4010da2e@linux.lan.towertech.it>
In-Reply-To: <alpine.LFD.2.11.1404192224250.11598@eddie.linux-mips.org>
References: <alpine.LFD.2.11.1404192224250.11598@eddie.linux-mips.org>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2014 23:58:20 +0100 (BST)
"Maciej W. Rozycki" <macro@linux-mips.org> wrote:

> This brings in drivers/char/rtc.c functionality required for DECstation 
> and, should the maintainers decide to switch, Alpha systems to use 
> rtc-cmos.

 Seems sane. We need to be sure it doesn't break anything
 on non-Alpha machines. Did you test it on x86? It would be fine if
 we can get a couple of Tested-by:
 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

