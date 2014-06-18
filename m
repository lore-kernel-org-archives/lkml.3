Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbaFRUMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:12:51 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:51040 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbaFRUMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:12:50 -0400
Date: Wed, 18 Jun 2014 23:12:41 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Russell King <linux@arm.linux.org.uk>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] omap3-n900.dts: Rename model name to "Nokia RX-51 board"
Message-ID: <20140618201241.GB558@drone.musicnaut.iki.fi>
References: <1403110635-29696-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403110635-29696-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 06:57:15PM +0200, Pali Rohár wrote:
> Use same name as in legacy board code. There are lot of userspace
> applications which using machine/model name for determinating device type.

Can you clarify this? Nokia kernel or userspace never had DT, so they
cannot see e.g. /proc/device-tree/model. What other APIs expose model?

A.
