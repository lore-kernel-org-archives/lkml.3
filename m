Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab3AQHMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 02:12:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33664 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930Ab3AQHMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 02:12:50 -0500
Date: Thu, 17 Jan 2013 16:12:43 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: s5m8767: Remove max_vol parameter from
 s5m8767_convert_voltage_to_sel
Message-ID: <20130117071242.GF20199@opensource.wolfsonmicro.com>
References: <1356745130.8271.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356745130.8271.1.camel@phoenix>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2012 at 09:38:50AM +0800, Axel Lin wrote:
> It looks pointless to pass max_vol to s5m8767_convert_voltage_to_sel().
> Compare selected voltage to desc->max is enough to ensure selected voltage
> is in supported range.

Applied, thanks.
