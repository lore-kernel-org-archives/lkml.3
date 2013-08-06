Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab3HFTql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 15:46:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58828 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab3HFTqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 15:46:40 -0400
Message-ID: <5201529C.5020409@wwwdotorg.org>
Date: Tue, 06 Aug 2013 13:46:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: balbi@ti.com, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu
Subject: Re: [PATCH v2 0/6] USB tree changes for Tegra30 and Tegra114 USB
 Host support
References: <1375812518-3847-1-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1375812518-3847-1-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 12:08 PM, Tuomas Tynkkynen wrote:
> Hi all,
> 
> Here are the patches for the USB tree to enable USB Host support on Tegra30 and
> Tegra114. These are based on my and Mikko's cleanup patches that just got
> merged to Felipe's tree.
> 
> The first one touches the core hub code to prevent certain (non-standard) clock
> disable features as our controller doesn't support those.
> The rest are changes to our PHY and EHCI drivers to deal with a few changed
> register addresses and a few additional PHY parameters that need to be set
> for proper signal quality.

The series,

Tested-by: Stephen Warren <swarren@nvidia.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>

(Tested on all of Tegra20/paz00, Tegra30/Beaver, Tegra114/Dalmore, all
with a USB NIC only)
