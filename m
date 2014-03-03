Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaCCIzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:55:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36828 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaCCIy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:54:59 -0500
Date: Mon, 3 Mar 2014 09:54:41 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 arm-soc tree
Message-ID: <20140303085441.GW6865@pengutronix.de>
References: <20140303190152.8b87330c0d83679b10c5ca5a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140303190152.8b87330c0d83679b10c5ca5a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 07:01:52PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm-current tree got a conflict in
> arch/arm/mach-vexpress/Kconfig between commit 9352b05b6e4e ("ARM: select
> MIGHT_HAVE_CACHE_L2X0 for V6 and V7 multi-platform") from the arm-soc
> tree and commit b096b0b50c4b ("Kconfig: rename HAS_IOPORT to
> HAS_IOPORT_MAP") from the akpm-current tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
your resolution and the two earlier ones from today[1] all look right

Best regards
Uwe

[1] The conflicts with

	ddb902cc3459 ("ARM: centralize common multi-platform kconfig options")
	9352b05b6e4e ("ARM: select MIGHT_HAVE_CACHE_L2X0 for V6 and V7 multi-platform")

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
