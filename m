Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaAQOm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:42:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61651 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaAQOmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:42:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH v16] dmaengine: Add MOXA ART DMA engine driver
Date: Fri, 17 Jan 2014 15:42:21 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org, vinod.koul@intel.com,
        djbw@fb.com, linux@arm.linux.org.uk, mark.rutland@arm.com,
        andriy.shevchenko@linux.intel.com, lars@metafoo.de
References: <1387189499-26300-1-git-send-email-jonas.jensen@gmail.com> <1389948365-13999-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1389948365-13999-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401171542.21970.arnd@arndb.de>
X-Provags-ID: V02:K0:lFbGwU/hQJLuYmabe2oHj6UYZpBem5/Kt5V1ohK8+lk
 1vxVfWX0LFkwXEMo2j89nnG4pACGtZBNlnTRDCg5aODwl3b3n1
 tIB6X3KASMhaSGWfgievARrMDrha9QbAyE2aGHvz67kFSH3sdO
 KKDP014z4jrYduYLkKfQRgxAhI5MSjPMHrXI/Mh8Yz2V0MVAsa
 0KRLmnrU7nxU2d9GZzd1bqXtQeefdk45Vvlbssb5dbmSfEIfeJ
 q5+FU3ddmLF1/IBxAvZ/5TwX+7tMYzE0uRZz993wBtt0+Gq55H
 9ccdcuPBRohYEHF6HbH3uM/Lcd2vh1+fl0mqcAd4gTdzUWOcX5
 B4Dl0bGa1B9BiNpIIQPk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 January 2014, Jonas Jensen wrote:
> The MOXA ART SoC has a DMA controller capable of offloading expensive
> memory operations, such as large copies. This patch adds support for
> the controller including four channels. Two of these are used to
> handle MMC copy on the UC-7112-LX hardware. The remaining two can be
> used in a future audio driver or client application.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---

Acked-by: Arnd Bergmann <arnd@arndb.de>
