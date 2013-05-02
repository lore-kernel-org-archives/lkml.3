Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444Ab3EBNbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:31:37 -0400
Received: from nm9.access.bullet.mail.sp2.yahoo.com ([98.139.44.136]:39954
	"EHLO nm9.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757786Ab3EBNbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:31:35 -0400
X-Yahoo-Newman-Id: 879202.48598.bm@smtp103.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: RF6bIGUVM1npUEgWiYPg4qwGz_yX1nXLtjWWYqZV523pzIQ
 7MbW0QXqsgsWJER8A4Y1lBVjtFV4t6xjSljZSGuRBql7pgAESp1F8Jnk3F7q
 wMIoEzFkIBh8XJXzLhK0_Za7rT7X45kqWQbKusE2KpUINHMobGapJUheUWkk
 ngJ34Qi0e5l74L6EtiR.x6tkWOmC6FcZ77_yP5gXQuS51LEhx5ctJsdigCG8
 imFE7pSjB2o1hHwTRk4I8I1VGk5SBRGXHoYd0HHs5w4H6cMxzR9O9QKnXTXA
 1A8X6fCzhjC6MM3FqKfo9Cr9GJ5t5qZvCcvs9PavZ6KejaxjNP6NGf7dHTHU
 Ka1ZMoVA8c4dpdUXu.P9DAPzLRT9JZsXSeTWa3KOj6QHyrBlQbsTCEMmyFDg
 Rqxo4rdghO.UtEns8X1gTMo_TUQ0Dyb3nrWcYetiHQAyczBcZ2YE.H1OAec0
 66sxjP1OGPZ.XDqyZUKVoVMUGz2o_GMW0Lg--
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp103.sbc.mail.ne1.yahoo.com with SMTP; 02 May 2013 13:31:34 +0000 UTC
Date: Thu, 2 May 2013 06:31:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH V3 7/7] watchdog: ts72xx_wdt: use devm_*() functions
Message-ID: <20130502133137.GA14103@roeck-us.net>
References: <000a01ce46f9$334257f0$99c707d0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000a01ce46f9$334257f0$99c707d0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 02:52:16PM +0900, Jingoo Han wrote:
> Use devm_*() functions to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>
