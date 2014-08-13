Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaHMMgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:36:33 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:57753 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaHMMg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:36:27 -0400
MIME-Version: 1.0
In-Reply-To: <f82330042cf6185a1f4e18232ebf6999662ae48f.1407931050.git.michal.simek@xilinx.com>
References: <f82330042cf6185a1f4e18232ebf6999662ae48f.1407931050.git.michal.simek@xilinx.com>
Date: Wed, 13 Aug 2014 14:36:26 +0200
X-Google-Sender-Auth: 3uEIOkqtGW2v45v9cXQnNflrD00
Message-ID: <CAAsK9AGD7x710OwxKxqf4CSEeiE3zmC5M3YDrDL9Bu0hpwPPqQ@mail.gmail.com>
Subject: Re: [PATCH] dma: xilinx: Remove .owner field for driver
From: Levente Kurusa <lkurusa@redhat.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        monstr@monstr.eu, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Srikanth Thokala <sthokal@xilinx.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-13 13:57 GMT+02:00 Michal Simek <michal.simek@xilinx.com>:
> There is no need to init .owner field.
>
> Based on the patch from Peter Griffin <peter.griffin@linaro.org>
> "mmc: remove .owner field for drivers using module_platform_driver"
>
> This patch removes the superflous .owner field for drivers which
> use the module_platform_driver API, as this is overriden in
> platform_driver_register anyway."
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Reviewed-by: Levente Kurusa <lkurusa@redhat.com>

Cheers,
Levente Kurusa
