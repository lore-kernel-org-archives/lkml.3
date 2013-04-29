Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab3D2SMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:12:01 -0400
Received: from nm16-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.19]:46680
	"EHLO nm16-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942Ab3D2SL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:11:59 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2013 14:11:59 EDT
X-Yahoo-Newman-Id: 656768.76157.bm@smtp120.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9lFedPAVM1nGU6_B8h3pRzBFdc4UMausFV5oblwEY3wOxot
 Dw3ofhzAjGX2Xt4IgPTRQOfoBlN9HL3LahzXv04dxNcIlWylgpffWF45cw.s
 .lAvRab1Ur6CUqiLkfsILoO2QYrVmMpQq_c34ya_AySdReTEPRVFVzYDmQhr
 9swBX_SPrkH4VKuveZ1csaYZ16YXtaeiXpeHbbXQQibEJG3oSX.izhJtF6NA
 ui1w6iqdrfqyunzkiVHu9ioiw_9TGjjAcuoDESyEU3v49LPeRNEegKWgWnIt
 UYV.jDdPaINxHGyqd0h0mZn1WD2zAayKHlzoarHppskG8GscOU6ccfQqMC7Q
 c1qNkkYcPiW0.pNgsBFmaCpUobSY_cM6Reo2ivPECzaQ5ugrC85c9IFoWq7F
 rsvUQ3ZbUhIS1KTxn7aMW4Upw_psVVhaXkXrOjye5x97vAOyeoa2HCqP_BXS
 GFwA90y8DQvAURefqIJWloZdCElwLbo63Ivu7hzE-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp120.sbc.mail.ne1.yahoo.com with SMTP; 29 Apr 2013 18:05:01 +0000 UTC
Date: Mon, 29 Apr 2013 11:05:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 5/7] watchdog: rc32434_wdt: use
 devm_ioremap_nocache() functions
Message-ID: <20130429180502.GE5183@roeck-us.net>
References: <000f01ce44bc$f1342570$d39c7050$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000f01ce44bc$f1342570$d39c7050$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 06:35:53PM +0900, Jingoo Han wrote:
> Use devm_ioremap_nocache() functions to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
