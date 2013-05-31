Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3EaNkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 09:40:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61547 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab3EaNkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 09:40:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Timur Tabi <timur@tabi.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v3 6/8] video: xilinxfb: Add support for little endian accesses
Date: Fri, 31 May 2013 15:38:08 +0200
Message-ID: <1991235.Da6plQRqqE@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <c1791574b211528b9f59af634018b7c83678f963.1370004925.git.michal.simek@xilinx.com>
References: <cover.1370004925.git.michal.simek@xilinx.com> <c1791574b211528b9f59af634018b7c83678f963.1370004925.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8WXDAJQBacO4JwVyXju6SanUU1oFMXCR5btWQ5aTOgY
 sOOMSm54xQaR4EuWvwCKwqeuZOIzfmI4R/XQf76KnrJGOj5oMt
 yT+ilDvT6hQvxZ/X1ujki5riontC4AEL4qcAIaAg70zcMeGbzW
 krOxoYzNj9GtHV25ngpQKmMco8acf3rn+4B0xBjV3gr5IPIa6r
 TaM0UPMrouzHubFAlLh5nDNBHohUKvAHTtaF2vQq82kIV4e+0i
 K5ykHRFbDHJAghwwFFvwB0HQWlYJXL5ZxIU5XxaJ7icdTpcSwe
 aDGJZ1m2C36sIiq1oFACCCO2ZyIlZ5hF7qQ/d1YE+3xE0crSdA
 dcLR2NFNm6SXSF733lOM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 May 2013 14:55:36 Michal Simek wrote:
> Dynamically detect endianess on IP and use
> ioread/iowrite functions instead of powerpc and microblaze
> specific out_be32.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
