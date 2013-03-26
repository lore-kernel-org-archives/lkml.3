Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab3CZSre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:47:34 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:39318 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3CZSrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:47:33 -0400
Date: Tue, 26 Mar 2013 18:47:32 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Suman Anna <s-anna@ti.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>
Subject: Re: [PATCHv3 02/14] ARM: OMAP2+: mbox: remove dependencies with
 soc.h
In-Reply-To: <1363145036-14407-1-git-send-email-s-anna@ti.com>
Message-ID: <alpine.DEB.2.00.1303261845390.23957@utopia.booyaka.com>
References: <1363145036-14407-1-git-send-email-s-anna@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 12 Mar 2013, Suman Anna wrote:

> The OMAP mailbox platform driver code has been cleaned up to
> remove the dependencies with soc.h in preparation for moving
> the mailbox code to drivers folder.
> 
> The code relied on cpu_is_xxx/soc_is_xxx macros previously to
> pick the the right set of mailbox devices and register with the
> mailbox driver. This data is now represented in a concise format
> and moved to the respective omap_hwmod data files and published
> to the driver through the platform data.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>

The hwmod/dev_attr parts look fine to me, but please start thinking about 
how to convert the driver to get this data from DT instead.


- Paul
