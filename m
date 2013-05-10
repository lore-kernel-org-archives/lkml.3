Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3EJO03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:26:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39957 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756103Ab3EJO01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:26:27 -0400
Date: Fri, 10 May 2013 10:26:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Venu Byravarasu <vbyravarasu@nvidia.com>
cc: gregkh@linuxfoundation.org, <swarren@wwwdotorg.org>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 04/10] Revert "usb: phy: tegra: don't call into
 tegra-ehci directly"
In-Reply-To: <1368194051-4925-5-git-send-email-vbyravarasu@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1305101024470.1313-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 May 2013, Venu Byravarasu wrote:

> This reverts commit ee5d5499edb94cd03738a52a7e234b139da8fd72.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
> As PHY is being registered as separate driver, solution proposed with
> this patch cannot work anymore.
> Hence pushed patch 10 of this series to address the issue.

You can't just revert a change like this -- doing so will recreate the 
original problem that ee5d5499ed was meant to fix.

You have to fix the problem _first_.  Then you can revert that commit.

Alan Stern

