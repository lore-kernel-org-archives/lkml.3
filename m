Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaGEPl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 11:41:29 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:64050 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaGEPl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 11:41:27 -0400
MIME-Version: 1.0
X-Originating-IP: [218.164.146.19]
In-Reply-To: <1404566456-9121-3-git-send-email-b.galvani@gmail.com>
References: <1404566456-9121-1-git-send-email-b.galvani@gmail.com>
	<1404566456-9121-3-git-send-email-b.galvani@gmail.com>
Date: Sat, 5 Jul 2014 23:41:26 +0800
Message-ID: <CAFRkauDR5A=oE0BPHfsyfw6giPsDX4CpYcgDnYQfeGO2nCWbuw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] regulator: act8865: prepare support for other
 act88xx devices
From: Axel Lin <axel.lin@ingics.com>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Wenyou Yang <wenyou.yang@atmel.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Heiko Stuebner <heiko@sntech.de>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-05 21:20 GMT+08:00 Beniamino Galvani <b.galvani@gmail.com>:
> This patch prepares support for other devices in the act88xx family of
> PMUs manufactured by Active-Semi.
>
> http://www.active-semi.com/products/power-management-units/act88xx/
>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> Tested-by: Wenyou Yang <wenyou.yang@atmel.com>

For this serial, Reviewed-by: Axel Lin <axel.lin@ingics.com>
patch 3/4 was not CCed to me, but I have checked the code on LKML mail list.

Regards,
Axel
