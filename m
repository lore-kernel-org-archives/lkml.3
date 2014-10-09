Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbaJIVZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:25:35 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:59259 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673AbaJIVKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Georgi Djakov <gdjakov@mm-sol.com>, galak@codeaurora.org,
        khilman@linaro.org, linux@arm.linux.org.uk,
        linux-arm-msm@vger.kernel.org, joshc@codeaurora.org,
        sboyd@codeaurora.org, linux-kernel@vger.kernel.org, olof@lixom.net
Subject: Re: [PATCH] ARM: qcom: Increase MMC_BLOCK_MINORS in defconfig
Date: Thu, 09 Oct 2014 23:09:39 +0200
Message-ID: <2943498.xucHPVCXbF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412843614-4537-1-git-send-email-gdjakov@mm-sol.com>
References: <1412843614-4537-1-git-send-email-gdjakov@mm-sol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Y4Pymmd/yHNfvU9+jwHi5o28nQrQu4eyRQovi35HrPI
 zeQlF9CERaXH28Dohat69wtfP5VrhjWXKPycRzgEg/DUCChat3
 q3dt3KOwYY6TtxJ+tfWAv9yOi8AytIveGVaURmCGPsySl3bDS9
 VGdQCc8bv/YjrEF6Vu6DQfi8vOXeHuyVbAbr+YaSDl0Wa3slPb
 6DWF+LzCVOyRHDa+bAOkSarWmsmIMxi1hyYZqlTPJFgiDn0ikn
 gs8BUgknYDSGdPA8KfbdGhH5wcykuFg3SxwFhHh7DPZnyMiG/U
 8Kvgal7n23FWjzMrDHYOvpKtRRvRAjATLL3tfHCyPM+Sfqx1cY
 NUrVyRvjc9Af39WYpe9A=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2014 11:33:34 Georgi Djakov wrote:
> There are currently more than 16 partitions on the eMMC of all recent
> Qualcomm devices. Increase the number of minors per block device to
> detect all available partitions.
> 

You should probably submit the same change for multi_v7_defconfig.

	Arnd
