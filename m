Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaAILFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:05:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56849 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaAILF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:05:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH v4 0/3] ata: ahci_platform: Add PHY support and OMAP support
Date: Thu, 9 Jan 2014 12:05:24 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: tj@kernel.org, sergei.shtylyov@cogentembedded.com, kishon@ti.com,
        b.zolnierkie@samsung.com, hdegoede@redhat.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <1389264962-22858-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1389264962-22858-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401091205.24818.arnd@arndb.de>
X-Provags-ID: V02:K0:K8HXdbjPdf6ZBFBplb1mr6POBe1fw88P161WEGzVJic
 kGXERazh7EM9YVaeeFepN4SrBiMV7cznYqjtcC5F4GKwszejdf
 quFDHh+kZqY0Cloz/gBROLRqno2fiGl2DyqvtUMENRkB7z9iaB
 CZJHDx2G7rbpHP+oq4rs91VRoZbsDruwmww1kPwfvBkpPIz8fs
 7nxpvjfYg5DQDzBO5P4MjGX9RRwDrF8Y3ip0TABCUiZp/anG+x
 j8XybOuFFXkYtPg/bwpWAbFxft/By40Pgopy99grR2HU6pwgHv
 eK+44pp3m/GO/+thcsvgoo9r83wCljSZWh++f4Q9YBCEuT5o1v
 EQaEZk/EWo9aAU1rVmj8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 January 2014, Roger Quadros wrote:
> Hi,
> 
> Some platforms have a PHY hooked up to the SATA controller.
> The PHY needs to be initialized and powered up for SATA to work.
> We do that using the Generic PHY framework in PATCH 2.
> 
> In order to support SATA on the OMAP platforms we need to runtime
> resume the device before use. PATCH 3 takes care of that.
> 
> PATCH 1 just updates the compatible list in the DT binding document.
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
