Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3A1HTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 02:19:23 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6062 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3A1HTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 02:19:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 27 Jan 2013 23:18:59 -0800
Date: Mon, 28 Jan 2013 09:18:55 +0200
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex A9
Message-ID: <20130128091855.9e89d6da79bf5a264449ea5e@nvidia.com>
In-Reply-To: <CAOesGMgtaCkiv285TU_vbAokN5M2MrANQ9piDcyXu5YMmbQq3A@mail.gmail.com>
References: <1358833924-24535-1-git-send-email-hdoyu@nvidia.com>
	<1358833924-24535-2-git-send-email-hdoyu@nvidia.com>
	<50FE2CA8.20100@ti.com>
	<50FEC503.2080602@wwwdotorg.org>
	<CAOesGMgtaCkiv285TU_vbAokN5M2MrANQ9piDcyXu5YMmbQq3A@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Tue, 22 Jan 2013 18:04:46 +0100
Olof Johansson <olof@lixom.net> wrote:

> Since Russell had comments on it earlier, I'd like him to give a nod
> that he's happy with it too.

Is this ok for you?

The original patch is:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-January/143552.html
