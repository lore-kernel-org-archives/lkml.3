Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3ANNc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 08:32:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51212 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756141Ab3ANNcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 08:32:24 -0500
Date: Mon, 14 Jan 2013 22:32:18 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, lrg@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] regulator: tps65090: add DT support
Message-ID: <20130114133216.GA25037@opensource.wolfsonmicro.com>
References: <1356686981-4152-1-git-send-email-ldewangan@nvidia.com>
 <1356686981-4152-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356686981-4152-3-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will inherit millions of dollars.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 02:59:39PM +0530, Laxman Dewangan wrote:
> Add DT support for TI PMIC tps65090 regulator driver. The DT of this
> device have node regulator and all regulator's node of this device is
> added under this node.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Seems sensible for this to go via MFD given that there's more MFD in the
series than regulator.
