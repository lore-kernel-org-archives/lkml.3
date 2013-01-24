Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab3AXQ1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 11:27:42 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59604 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754689Ab3AXQ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 11:27:39 -0500
Date: Thu, 24 Jan 2013 11:27:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: linux-usb@vger.kernel.org, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>, <kgene.kim@samsung.com>,
        <thomas.abraham@linaro.org>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <sylvester.nawrocki@gmail.com>,
        <dianders@chromium.org>, <jg1.han@samsung.com>, <cpgs@samsung.com>
Subject: Re: [PATCH v2 1/2] usb: ehci-s5p/ohci-exynos: Fix compatible strings
 for the device
In-Reply-To: <1359035130-22667-2-git-send-email-gautam.vivek@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1301241127270.2163-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2013, Vivek Gautam wrote:

> Using specific chip in compatible strings. Newer SOCs can claim
> device by using older string in the compatible list.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Reviewed-by: Doug Anderson <dianders@chromium.org>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

