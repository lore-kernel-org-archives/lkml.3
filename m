Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934592Ab3CZPB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:01:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61960 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933659Ab3CZPB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:01:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2 3/4] dw_dmac: make wrapper on of_dma_controller_register()
Date: Tue, 26 Mar 2013 15:01:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel@vger.kernel.org, "spear-devel" <spear-devel@list.st.com>
References: <1364309637-25860-1-git-send-email-andriy.shevchenko@linux.intel.com> <1364309637-25860-4-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1364309637-25860-4-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303261501.23671.arnd@arndb.de>
X-Provags-ID: V02:K0:Yuk6JU+MnAuV48jDiLIoQqS+JBQk1X09BFC4dSpApFh
 LX20sl/SROb2sxM9ko/1dKHhTNWwPfmokYjZdOdDQoiYf09GE1
 GK2LdYCSTQ25sC91fpjp48DnROpB0UfUwxn4LSDIbisBCaeb7T
 twm3nhxGdXAQQNEFbsmpkj6vAXSrpXelmYdDko2cx2lHCmH1jC
 9SJ6xL0Z1lfPn0ObURs4RCW0rF60VVo71APxnfEmWfIjiix/hK
 R5ycgU0Ty/7c/Tg3a9CmgpowC3heHD1L9g3aLuei7GHgMOsh/U
 PcLwjVsNLjK4fjMBWYRqfBNqbETirRD1FhR4XaoeCxVlFbwZmY
 IK/LprX3WdXEbHaaCZHg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 March 2013, Andy Shevchenko wrote:
> This patch introduces new method dw_dma_of_controller_register() and adds
> checks of the of_node presence together with CONFIG_OF before calling the
> wrapper. It helps to distinguish the real -ENODEV return code of fake one when
> of_dma_controller_register is not implemented.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks for the update
