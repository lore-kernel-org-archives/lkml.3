Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3ARPiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:38:13 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43609 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752570Ab3ARPiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:38:10 -0500
Date: Fri, 18 Jan 2013 10:38:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: linux-usb@vger.kernel.org, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>, <kgene.kim@samsung.com>,
        <thomas.abraham@linaro.org>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <sylvester.nawrocki@gmail.com>,
        <dianders@chromium.org>, <jg1.han@samsung.com>, <p.paneri@samsung.com>
Subject: Re: [PATCH v6 4/4] USB: ohci-exynos: Add phy driver support
In-Reply-To: <1357916550-11421-5-git-send-email-gautam.vivek@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1301181037500.1988-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013, Vivek Gautam wrote:

> Adding the phy-driver to ohci-exynos. Keeping the platform data
> for continuing the smooth operation for boards which still uses it
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

