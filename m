Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966874Ab3DRLL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:11:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50080 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966226Ab3DRLL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:11:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 28/32] ARM: ux500: Pass remnant platform data though to DMA40 driver
Date: Thu, 18 Apr 2013 13:11:21 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-29-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366279934-30761-29-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181311.21863.arnd@arndb.de>
X-Provags-ID: V02:K0:1FTv4KpKG8LfGDW4Mg/wTIcCmduDqgPQeodFw5xPHEb
 u/K/a8MXj04eElOrRG39fkv0wCAzjLCwYR0+0xJc0KcwAT2EXi
 GrGI5JXCjQh8tEmhqbtmKMMpjlxCfjCYT/CA3s7PI1yOmW7EnV
 uxXwqVokR9tE7o7VmgbxeJQuCEI2EpoBHPpr5a3PxAvVd9Wqh0
 yN6n0k+0TGK2B9aCOL8cpnSzGrCrfGIozniUklqlMk3YpRLhEZ
 uxT//VszoFEEHCFx4INXKLqhpgyooBP90Y94Zg/8PtVgM/5tX9
 +ixXiSOXt7iD/Krqvv2Vm4p3UsrXW3jiwKjE+Y6uU5+zRDzUXU
 7xtnN5Ic+XJigzHpf4yw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> Ironically, in order to remove lots of the auxdata assignments, we have
> to add just one more. A lot of them require DMA information to be passed
> into clients for DMA channel allocation, but we now have this capability
> in Device Tree. However, the DMA40 driver still relies on a reverse table
> look-up to obtain DMA addresses. Until all of the clients are converted,
> over to the new API, we're stuck with this.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

but please fold this together with patch 27, since applying one without the
other breaks booting.

	Arnd
