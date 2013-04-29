Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab3D2Qlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:41:50 -0400
Received: from nm3.access.bullet.mail.mud.yahoo.com ([66.94.237.204]:35254
	"EHLO nm3.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757623Ab3D2Qlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:41:47 -0400
X-Yahoo-Newman-Id: 536523.10983.bm@smtp106.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ByUJOHsVM1mYCSsTfiNlIGR9o6YW4eplb4JgrSZylB4MSOe
 luR2bYvZ9Chraf.c06mMvytUtHa_q5nxfo3DtRwk7eKpq8lawkzUP_Q7eMei
 9ADalaPwuu9dl4w_RrrfbfwjJiiqso_DJvyOcr0Q7SuuXzFeZa1ZAM0aHsj7
 Hfnj8EGSbkC.DHYWORGYPCkXBVpn6kliKmvRl_PoC.fGRXsqIzJeGkKB1hyu
 TVtdOs1gUmpHEGHy3Xp8zYceP7wpNPVeUNROcCm8r25t6iIq29hVqczy5ArE
 bpgdIYdduJj_j8W.ghHUBnUIjGfSqve_fJyzo.lH1zGObcZVnE6FwjhMKbWB
 ZeUuZeAMn69PFz4Iuk5bxBfUaG_lSe23A08nCA88Fxu7LijmzFY.6fDGahNm
 47JkvtD9nBwlmD2pIfcPmT_71wTVqsKRAVug8qu4HgJenLdq2oXZm7lVmzw-
 -
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp106.sbc.mail.ne1.yahoo.com with SMTP; 29 Apr 2013 09:41:46 -0700 PDT
Date: Mon, 29 Apr 2013 09:41:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 2/2] watchdog: wm831x_wdt: use
 devm_gpio_request_one()
Message-ID: <20130429164146.GI23799@roeck-us.net>
References: <000a01ce44bc$4ebef180$ec3cd480$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000a01ce44bc$4ebef180$ec3cd480$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 06:31:20PM +0900, Jingoo Han wrote:
> Use devm_gpio_request_one() to make cleanup paths simpler.
> Also, GPIOF_DIR_OUT | GPIOF_INIT_LOW is replaced with
> GPIOF_OUT_INIT_LOW.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
