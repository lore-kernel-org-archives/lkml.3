Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3JHU67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:58:59 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:34397 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab3JHU64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:58:56 -0400
X-Auth-Info: 1c48JL+p7gXL2sj1UytNrrHcPObKiM31PkVvRJyEbmo=
From: Marek Vasut <marex@denx.de>
To: Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 3/9] i2c: i2c-mxs: replace platform_driver_probe to support deferred probing
Date: Tue, 8 Oct 2013 22:58:57 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1381264542-29396-1-git-send-email-wsa@the-dreams.de> <1381264542-29396-4-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1381264542-29396-4-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201310082258.57659.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Wolfram Sang,

> Subsystems like pinctrl and gpio rightfully make use of deferred probing at
> core level. Now, deferred drivers won't be retried if they don't have a
> .probe function specified in the driver struct. Fix this driver to have
> that, so the devices it supports won't get lost in a deferred probe.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> Cc: Marek Vasut <marex@denx.de>

Certainly makes sense,

Acked-by: Marek Vasut <marex@denx.de>

Thanks!

Best regards,
Marek Vasut
