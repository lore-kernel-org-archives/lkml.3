Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3CBEKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 23:10:42 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:38983 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3CBEKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 23:10:41 -0500
MIME-Version: 1.0
Date: Sat, 2 Mar 2013 09:40:40 +0530
Message-ID: <CAK9yfHw7-LJx31poPqxn_GRfEDyfReqeYTPX7Fqwzi7vtC98UQ@mail.gmail.com>
Subject: Boot failure on Origen board using latest kernel
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Padmavathi Venna <padma.v@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Koul, Vinod" <vinod.koul@intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Padma,

While trying to boot the latest mainline kernel (Linus tree tip at
commit b0af9cd9) on Exynos4210 based Origen board, it stops at
"Uncompressing Linux... done, booting the kernel."

Git bisect pointed to the commit 421da89aa ("DMA: PL330: Register the
DMA controller with the generic DMA helpers").
Reverting this commit helped me boot the board again.
Could you please look into this?

-- 
With warm regards,
Sachin
