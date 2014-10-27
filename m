Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaJ0W1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:27:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbaJ0W1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:27:31 -0400
Message-ID: <544EC6CE.6090107@suse.de>
Date: Mon, 27 Oct 2014 23:27:26 +0100
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Roman Byshko <rbyshko@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
CC: Mark Rutland <mark.rutland@arm.com>, Russell King <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 0/5] ARM: sunxi: Add support for USB OTG PHY
References: <cover.1414444953.git.rbyshko@gmail.com>
In-Reply-To: <cover.1414444953.git.rbyshko@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman,

Am 27.10.2014 um 22:43 schrieb Roman Byshko:
> There is already support for two USB phys, which are used for
> USB host controllers on Allwinner SoC aka sunxi.
> 
> This patch series add support for the USB OTG phy (aka phy0).
> 
> The code has been tested on Allwinner A20 aka sun7i (Cubietruck).

All these patches are lacking a Signed-off-by.

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
