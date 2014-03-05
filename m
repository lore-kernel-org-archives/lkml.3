Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbaCEXS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 18:18:28 -0500
Received: from smtp.math.uni-bielefeld.de ([129.70.45.10]:38491 "EHLO
	smtp.math.uni-bielefeld.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753448AbaCEXS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 18:18:26 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2014 18:18:26 EST
Message-ID: <5317AE67.3040503@math.uni-bielefeld.de>
Date: Thu, 06 Mar 2014 00:08:23 +0100
From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:27.0) Gecko/20100101 Firefox/27.0 SeaMonkey/2.24
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
CC: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, stern@rowland.harvard.edu, sander@humilis.net
Subject: Re: [PATCH v9 0/4] phy: Add new Exynos USB 2.0 PHY driver
References: <1394033288-5551-1-git-send-email-k.debski@samsung.com>
In-Reply-To: <1394033288-5551-1-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kamil,

this looks very good. I just tested the patchset on my ODROID-X2
(Exynos4412-based board) and the USB stability issues I mentioned to you
before (with the older patchset) seem to be gone.

All devices on the USB behave normally (mass storage, ethernet and
bluetooth).


With best wishes,
Tobias


