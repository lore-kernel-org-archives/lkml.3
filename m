Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703Ab3GaSfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 14:35:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37185 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760249Ab3GaSfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 14:35:48 -0400
Date: Wed, 31 Jul 2013 14:35:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
cc: balbi@ti.com, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <gregkh@linuxfoundation.org>,
        Matthieu CASTET <matthieu.castet@parrot.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCH 1/6] usb: host: add has_tdi_phy_lpm capability bit
In-Reply-To: <1375292522-7855-2-git-send-email-ttynkkynen@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1307311435340.1546-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jul 2013, Tuomas Tynkkynen wrote:

> The has_hostpc capability bit indicates that the host controller has the
> HOSTPC register extensions, but at the same time enables clock disabling
> power saving features with the PHY Low Power Clock Disable (PHCD) bit.
> 
> However, some host controllers have the HOSTPC extensions but don't
> support the low-power feature, so the PHCD bit must not be set on those
> controllers. Add a separate capability bit for the low-power feature
> instead, and change all existing users of has_hostpc to use this new
> capability bit.
> 
> The idea for this commit is taken from an old 2012 commit that never got
> merged ("disociate chipidea PHY low power suspend control from hostpc")
> 
> Inspired-by: Matthieu CASTET <matthieu.castet@parrot.com>
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

