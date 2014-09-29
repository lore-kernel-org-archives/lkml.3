Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaI2OJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:09:25 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56455 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaI2OJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:09:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: zhang.lyra@gmail.com, catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org,
        broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com,
        pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com,
        robh+dt@kernel.org, will.deacon@arm.com, orsonzhai@gmail.com,
        geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Add Spreadtrum Shark64 SoC support
Date: Mon, 29 Sep 2014 16:08:03 +0200
Message-ID: <4929446.AOyTEh2uOW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:eqUn18VNIJN0zeAxjEeo4M4wBbAQZxjpoEd5BSfgAjM
 bC9+ChOKO9HNYqtV2z49utnnlYzccD36mBR+N9UzJjQcVi5U69
 OvOKWU47iwOpteJ6tCtW5PLAFPQdPxKg3HLw2MfZJBujWKggL0
 0q2rhxozMcfmZEZ96iv2EFmhA3aF9Wy/ChOqfTmR66PhHszSn1
 wEyf5ZDzEUF36Pvrk+6XViCsYR7gfxiLr79CDl7GBiPeDGICec
 p2RteJ8f8K5P9zZJ5o/wdokIOYQgdGQUBgCQ9xNPWl1O9/Bq/2
 nbtiLj77aCZeYBvSh3MEkdHnBwA+E1joeb3ULpcSQ8a8HdSYmD
 0BVO5f0Pmrv5geS6DM68=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 September 2014 20:04:47 zhang.lyra@gmail.com wrote:
> From: "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
> 
> Spreadtrum is a rapid growing chip vendor providing smart phone total solutions. 
> Shark64 is nominated as a SoC infrastructure that supports 4G/3G/2G standards based on ARMv8 multiple core architecture.
> 
> This patchset adds shark64 supports in arm64 device tree and implements the basic earlycon serial driver.

Hi Lyra and/or Chunyan,

Thanks for your submission, it's great to see another company join the
upstream submission process.

Your patches look good overall, but I have replied with a few comments
on the details that need to be worked out.

	Arnd
