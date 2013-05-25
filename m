Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab3EYSty (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 14:49:54 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:47880 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757624Ab3EYStx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 14:49:53 -0400
Date: Sat, 25 May 2013 20:49:48 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        "'Guenter Roeck'" <linux@roeck-us.net>
Subject: Re: [PATCH V2 1/7] watchdog: at32ap700x_wdt: use devm_*() functions
Message-ID: <20130525184948.GA12304@spo001.leaseweb.com>
References: <000d01ce455f$8a789110$9f69b330$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000d01ce455f$8a789110$9f69b330$@samsung.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

> Use devm_*() functions to make cleanup paths simpler.
> 
> Acked-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch added to linux-watchdog-next.

Kind regards,
Wim.

