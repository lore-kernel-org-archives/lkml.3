Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab3ARPht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:37:49 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43593 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750985Ab3ARPhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:37:48 -0500
Date: Fri, 18 Jan 2013 10:37:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: linux-usb@vger.kernel.org, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>, <kgene.kim@samsung.com>,
        <thomas.abraham@linaro.org>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <sylvester.nawrocki@gmail.com>,
        <dianders@chromium.org>, <jg1.han@samsung.com>, <p.paneri@samsung.com>
Subject: Re: [PATCH v6 3/4] USB: ehci-s5p: Add phy driver support
In-Reply-To: <1357916550-11421-4-git-send-email-gautam.vivek@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1301181037200.1988-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013, Vivek Gautam wrote:

> Adding the phy driver to ehci-s5p. Keeping the platform data
> for continuing the smooth operation for boards which still uses it
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

