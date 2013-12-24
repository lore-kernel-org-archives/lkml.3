Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab3LXMZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 07:25:26 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33340 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab3LXMZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 07:25:25 -0500
Date: Tue, 24 Dec 2013 12:24:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20131224122455.GY30815@sirena.org.uk>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
 <1387815830-8794-11-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387815830-8794-11-git-send-email-pawel.moll@arm.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 81.132.50.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 10/18] regulator: vexpress: Use regmap instead of custom
 interface
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 04:23:42PM +0000, Pawel Moll wrote:

> This patch makes the Versatile Express regulator driver
> use regmap interface, instead of custom vexpress config
> one. It will request the regmap resource associated
> with the device, which makes it pretty much hardware
> agnostic.

If this change is making the operations hardware agnostic regmap based
ones then they should be being either replaced with standard operations
or standard operations being added.  It looks like you should be able to
use the existing linear map operations.
