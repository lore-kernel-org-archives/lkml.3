Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965760AbaDJJqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:46:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:49763 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965484AbaDJJqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:46:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        t.figa@samsung.com, linux-samsung-soc@vger.kernel.org,
        hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, yj44.cho@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 03/27] ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
Date: Thu, 10 Apr 2014 11:46:16 +0200
Message-ID: <4996376.GgWd9rnCP3@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1397122124-15690-4-git-send-email-cw00.choi@samsung.com>
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com> <1397122124-15690-4-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1IvTD/oLAGF3dzsQl+jTqLlxzd8K2+e8M9/yh5W9gtk
 kwfZBdHmij6AM5ubSR+9KeaTGwnrOZ/Xj5KHkdvVFAJxZPwjsy
 NZyd2+t/vnqd4o8bT8Kk2qK2qIEXrfR9m9Ldn9UVRMs94RFLtA
 N0ruLlt0OeLwtA+t6RAC93lifYYGqGRAiVHXCyk2Xjqbo9FANL
 GDof2jKluJ2zDSBOwJF+/VJFN4QTV8MtRwBBWxpZc8DtRgmkhz
 hpCicEiiyKbPAdc/QaP5Ubf3P0TLFK6NVazIIm5IEDZEIlsaUG
 BxCL3sJhwwZsgW8KpXb1FdyBmWPY6ExmnPHa5xeZDaj8b8b17Y
 KdNjVMd2LhWwwvIsLvfU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 April 2014 18:28:20 Chanwoo Choi wrote:
> This patch add memory mapping for PMU (Power Management Unit) which is used
> for power control of Exynos3250.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Same thing as for the SRAM here, can you work on making this a proper
driver instead?

	Arnd
