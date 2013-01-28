Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab3A1Otu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:49:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56721 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3A1Ots (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:49:48 -0500
Date: Mon, 28 Jan 2013 14:47:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex A9
Message-ID: <20130128144759.GK23505@n2100.arm.linux.org.uk>
References: <1358833924-24535-1-git-send-email-hdoyu@nvidia.com> <1358833924-24535-2-git-send-email-hdoyu@nvidia.com> <50FE2CA8.20100@ti.com> <50FEC503.2080602@wwwdotorg.org> <CAOesGMgtaCkiv285TU_vbAokN5M2MrANQ9piDcyXu5YMmbQq3A@mail.gmail.com> <20130128091855.9e89d6da79bf5a264449ea5e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128091855.9e89d6da79bf5a264449ea5e@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 09:18:55AM +0200, Hiroshi Doyu wrote:
> Hi Russell,
> 
> On Tue, 22 Jan 2013 18:04:46 +0100
> Olof Johansson <olof@lixom.net> wrote:
> 
> > Since Russell had comments on it earlier, I'd like him to give a nod
> > that he's happy with it too.
> 
> Is this ok for you?
> 
> The original patch is:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-January/143552.html

Yes, this version is much better, thanks.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
