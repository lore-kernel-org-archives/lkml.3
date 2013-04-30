Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3D3FcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 01:32:17 -0400
Received: from nm15.access.bullet.mail.sp2.yahoo.com ([98.139.44.142]:25548
	"EHLO nm15.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290Ab3D3FcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 01:32:15 -0400
X-Yahoo-Newman-Id: 529157.6985.bm@smtp110.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: CU.egW8VM1mpyGExCgSzLiX6AoEGI6sSInee_Ks7tTVpCB1
 MC25ROTXk5koKrLDYOAjGIzJPM9yUvAAQpFerfiKYwkGR1ctME.3NE0CHFxD
 TgAlnxSQoRQtZeMYqZzB32gbdQ2kPb6j5c3QwGs0aHNIhp_RX0nhUlU9l2B4
 jzUrnaToJEnXJTzWkPomq4SLm4pCWKhokleC.sk3NOt7USYCp0dwulWnlPx7
 EJXO80_ODvXtDTA1offFBOZsu0kRmxh24GRVUG8TgjNZ6xXnvjVjIH09IksB
 MOlWsDtiG9K_xzDH8E2q7ruog9yQ_AWZyTSWzJAIfgNI_JQUcaYAMqThAC1T
 BO9THaUmEhTnCY8te1beJ_CgnDpHI2eHWOpY76HV6CZEp5FzyeUgkO343bdu
 kDd.fLLlAv01vcSgK9DqtRryachqK0cK0t_WrEZBmSqGe_J5mBMG11rsxJdJ
 .2f1PSa_qNd_CbB4y6E7mUeW8iPLYgxeo9g--
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp110.sbc.mail.gq1.yahoo.com with SMTP; 29 Apr 2013 22:32:15 -0700 PDT
Date: Mon, 29 Apr 2013 22:32:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH V2 4/7] watchdog: nuc900_wdt: use devm_*() functions
Message-ID: <20130430053214.GA4559@roeck-us.net>
References: <001101ce455f$c441cf60$4cc56e20$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001101ce455f$c441cf60$4cc56e20$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 02:01:25PM +0900, Jingoo Han wrote:
> Use devm_*() functions to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Changes since v1:
> - used sizeof(*nuc900_wdt) instead of sizeof(struct nuc900_wdt)
> - declared 'nuc900_wdt->res' variable as logical variable
> 
You mean 'local'.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
