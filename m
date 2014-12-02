Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037AbaLBUpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:45:44 -0500
Received: from mout.gmx.net ([212.227.15.15]:58769 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932654AbaLBUpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:45:42 -0500
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: Re: [PATCH] char: tpm: Add missing error check for devm_kzalloc
Date: Tue, 2 Dec 2014 21:51:05 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-rc6-dirty; KDE/4.12.5; x86_64; ; )
Cc: ashley@ashleylai.com, tpmdd@selhorst.net,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kiran.padwal21@gmail.com
References: <1411110879-4106-1-git-send-email-kiran.padwal@smartplayin.com>
In-Reply-To: <1411110879-4106-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201412022151.05517.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:PoEbjctfbgQ29vu+5azimtXTrp0Cd31GrGOqObIgriV3Ultlo6j
 eri4Ze0avHYHpeaXaA7/kKuTdVLODyOkCi7kVh90m+N1v2++bvoFb2KnvWfLV9rjbtAJnL7
 ainTSU2aAVMBZA3chaFoVlpovY5A10oBMW32bMi+V6FMV9MQx4FYGpPO6V3VRFmhTGiHi6K
 zGpwE2/UVRw4nxBaM5B9Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 19. September 2014, 09:14:39 schrieb Kiran Padwal:
> Currently these driver are missing a check on the return value of
> devm_kzalloc, which would cause a NULL pointer dereference in a OOM
> situation.
> 
> This patch adds a missing check for tpm_i2c_atmel.c and tpm_i2c_nuvoton.c
> 
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
Applied to my tree:
https://github.com/PeterHuewe/linux-tpmdd for-james

Will be included in the next pull-request.

Thanks,
Peter
