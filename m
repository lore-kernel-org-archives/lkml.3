Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaGWM2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:28:38 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:58306 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaGWM2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:28:36 -0400
X-Auth-Info: fj18NAnzro8EYITOCSBlMU4ief78M6ZI2QMPwaMWfz8=
From: Marek Vasut <marex@denx.de>
To: Yuan Yao <yao.yuan@freescale.com>
Subject: Re: [PATCH v5 0/2] i2c: add DMA support for freescale i2c driver
Date: Wed, 23 Jul 2014 14:28:01 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: wsa@the-dreams.de, mark.rutland@arm.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
References: <1406103883-3572-1-git-send-email-yao.yuan@freescale.com>
In-Reply-To: <1406103883-3572-1-git-send-email-yao.yuan@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201407231428.01278.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 23, 2014 at 10:24:41 AM, Yuan Yao wrote:
> Changed in v5:
> - add "*chan_dev = dma->chan_using->device->dev" for reduce the call time.

Did you check if the compiler generates different code ?

> - add the test logs.

[...]

Best regards,
Marek Vasut
