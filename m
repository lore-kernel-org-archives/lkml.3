Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbaDWNiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:38:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:59156 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaDWNiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:38:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH v8] mmc: moxart: Add MOXA ART SD/MMC driver
Date: Wed, 23 Apr 2014 15:37:37 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: chris@printf.net, ulf.hansson@linaro.org, linux-mmc@vger.kernel.org,
        cjb@laptop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, mark.rutland@arm.com
References: <1390301550-478-1-git-send-email-jonas.jensen@gmail.com> <1397051651-29501-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1397051651-29501-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201404231537.37396.arnd@arndb.de>
X-Provags-ID: V02:K0:KWHFXYIUePW+FpPYv8FuWSkgvE0tPV/jH3kisp3NcAx
 KZ37OKj/awWUnnVX/HZaBBWX3itS5zkIXsTbyGWWSX+W0HyeXC
 RzwXUf2dSJNTcYHMq7tsEpvXbo7BAqNcC6YmgALBV/gPRN7Wk1
 RnE+1wYMESENXbxVu3kRBgUhSiOUvU43UyvCgu/gBLMFrys44W
 IYcmJrTTLh99jAv5vZv11LwvWDFOdiu0nuXBteSFj1NQAeCAeP
 Jx6qdqFMtpg8xvoRoi1SWxDDHMs/R0X1wbaDB2Mn+TtAWJKvEh
 RpHGjEYx3B0purEhGZnU2XLOYOCSkDQwOxhjD6DiIavoppE3sX
 vPphhXazdH7Sadiz2Bs0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 April 2014, Jonas Jensen wrote:
> Add SD/MMC driver for MOXA ART SoCs.
> 
> The "MOXA ART MMC controller" is likely a faraday "ftsdc010",
> a controller with support in U-Boot:
> 
> http://git.denx.de/?p=u-boot.git;a=blob;f=drivers/mmc/ftsdc010_mci.c
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
