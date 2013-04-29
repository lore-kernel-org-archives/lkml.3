Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab3D2QfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:35:01 -0400
Received: from nm21-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.176]:47412
	"EHLO nm21-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757163Ab3D2Qe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:34:59 -0400
X-Yahoo-Newman-Id: 278705.67293.bm@smtp112.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9AOF4Z4VM1kFHVVfIhRyMsmFjn3_ArRTfrP83es8Il5vqrO
 AS6IwLccojO5o9.XgF0wDJHgdfw7EMuu8Bz23Jrw0uI0YwtBKCUwa9B6P6cZ
 TmcfGs_2ZVmT5O1vdTxLZHIKIJwfa24uHxo36Tg2Y_5czY0aBh4.qj7bgASZ
 pGi0TeKQE35CY3uu7qwWS5OKy1AMbxknhvXm53jU3XHyKSDxtFaRY_ecDy6z
 USyrFJ9VE3m0bCxcRhIIJIS6eQ_wAt.EuAvsUnvCSlUpZhhFBoBxd3XerzA8
 ZnMcHPnlFuDmdt5cZt35HClwSRYdUTgR_0sOBYMplwvjmvFRYIY8v17FdtFA
 0bNUw0.tuHP_QT0OoDrKjXgIQdrvE3d1FT10Qc94pLBwm4_jNbZQxOe2r_3S
 OL8VVNkpE_sKd_EG4aHXYS5bW6ZBRXBTkd663LzT1eoootNdKMq6V.gtXVc6
 GqQarU14GOoUpejpN.mrt3xoC_XNoIgZ5_rDgGDE-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp112.sbc.mail.gq1.yahoo.com with SMTP; 29 Apr 2013 09:34:59 -0700 PDT
Date: Mon, 29 Apr 2013 09:34:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 1/2] watchdog: s3c2410_wdt: use
 dev_err()/dev_info() instead of pr_err()/pr_info()
Message-ID: <20130429163459.GG23799@roeck-us.net>
References: <000701ce44bb$96f4ecd0$c4dec670$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000701ce44bb$96f4ecd0$c4dec670$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 06:26:12PM +0900, Jingoo Han wrote:
> dev_err()/dev_info() are more preferred than pr_err()/pr_info().
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
