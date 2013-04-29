Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3D2QiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:38:19 -0400
Received: from nm10-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.122]:38368
	"EHLO nm10-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757856Ab3D2QiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:38:17 -0400
X-Yahoo-Newman-Id: 917987.18069.bm@smtp118.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: mbnDaQ0VM1kkNBUlBwvP9kZSuSn_pY6ptkeeTcU3z4sJndO
 h62FSHix8WzFU3Z7rLPu8h4uKug6n2WoNbnPXGY0Myvac6NyYWUa_q4zUmYk
 EnKVenTfN9KUJJXOTnaSRd3XVY39Ga.FeJV1NZ7aVdC47AOH.QsDxJ2BMlFj
 fTtPJDDitjM1ge1dggZB_lfZk5mG0cE5btenL05JR1WUzr6fDTZhEVNtD1Jf
 rTl8II8QJ0FuarFbS2yYytfNFgwrf2.EHAHpO.wmR2GgZ4hZohZrW4.U3SmY
 qCGoAl0MgFRO8Az.8DRRZaC80iW.FSzHQWt1.w3BH24SO3QGk6VRS61HrLKx
 0IvwspglT.ID7bsaWikpi4zNS_I3186.ez9gWx_gDk.deAgVufWZLAzGXjOb
 A1MJyr8e42woNP2i1MJS3tYLizWJJiEv1Qir29hcY4R2jLXyRKR67qsVUEZb
 WemD2wuEkY63t3Hjl7C6btzLh0EXI6fvong--
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp118.sbc.mail.gq1.yahoo.com with SMTP; 29 Apr 2013 16:38:16 +0000 UTC
Date: Mon, 29 Apr 2013 09:38:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 2/2] watchdog: s3c2410_wdt: convert s3c2410wdt to
 dev_pm_ops
Message-ID: <20130429163817.GH23799@roeck-us.net>
References: <000801ce44bb$a877ce00$f9676a00$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000801ce44bb$a877ce00$f9676a00$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 06:26:41PM +0900, Jingoo Han wrote:
> Instead of using legacy suspend/resume methods, using newer
> dev_pm_ops structure allows better control over power management.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
