Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaAPLD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 06:03:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55149 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbaAPLDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 06:03:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv9 2/2] dma: Add Freescale eDMA engine driver support
Date: Thu, 16 Jan 2014 12:02:48 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, shawn.guo@linaro.org,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Alison Wang <b18965@freescale.com>
References: <1389839400-29728-1-git-send-email-b35083@freescale.com> <1389839400-29728-3-git-send-email-b35083@freescale.com>
In-Reply-To: <1389839400-29728-3-git-send-email-b35083@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401161202.49333.arnd@arndb.de>
X-Provags-ID: V02:K0:SRSJh6C0fi8RFntrcqL/62byA5BADRCFXz0bVGJsTOw
 esFhyJqrN9DREoGAPh2owT+GFFpgyiWujdvT1uwpQAN3rcc9Er
 ZhisBiNV4yUOLzY5A00ZRK3dKrOdxCdbTkDWuQmgGSFLtVFdI2
 adP5YSnJUn85hHGSgyxkqhs3NFuy2SQANsw5SWVYVdl3jSz2E7
 BTsM+QHolEjhR72s+aXvuwtfFC7IY960gBDYcR7GtYwdUwLDOj
 xSrma8KrKsw1eEnZUjckbgkTPisk0CJ3KJnd5ItHhsgtEoUoXZ
 FNRziOcd7W5LFr4Kf2q/PgmopaUjq6koeqnNH/bbg1HLSlfPGO
 rUnGo0N+5Ooo553evd/I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 January 2014, Jingchang Lu wrote:
> Add Freescale enhanced direct memory(eDMA) controller support.
> This module can be found on Vybrid and LS-1 SoCs.
> 
> Signed-off-by: Alison Wang <b18965@freescale.com>
> Signed-off-by: Jingchang Lu <b35083@freescale.com>

Very nice! All my previous comments have been addressed, so

Acked-by: Arnd Bergmann <arnd@arndb.de>

One small comment still:

> +
> +static DEFINE_MUTEX(fsl_edma_mutex);
> +

I think this mutex should be part of struct fsl_edma_engine, not global.

	Arnd
