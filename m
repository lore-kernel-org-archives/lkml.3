Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaK0ItN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:49:13 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:61462 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbaK0ItI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:08 -0500
Date: Thu, 27 Nov 2014 08:49:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: linux-next: manual merge of the devicetree tree with the pm, mfd
 and regulator trees
Message-ID: <20141127084902.GC4628@x1>
References: <20141126154406.434ab873@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141126154406.434ab873@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Today's linux-next merge of the devicetree tree got a conflict in
> include/linux/of.h between commits b31384fa5de3 ("Driver core: Unified
> device properties interface for platform firmware") from the pm tree
> and a4b4e0461ec5 ("of: Add standard property for poweroff capability")
> from the mfd and regulator trees and commit 7518b5890d8a ("of/overlay:
> Introduce DT overlay support") from the devicetree tree.

This patch actually originated from the Regulator tree.  I pulled it in
to avoid conflicts between MFD and Regulator.  I guess OF needs to do
the same to avoid a conflict when Linus pulls them in.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
