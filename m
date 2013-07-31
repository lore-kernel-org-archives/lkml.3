Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab3GaXaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 19:30:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40470 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3GaXaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 19:30:13 -0400
Message-ID: <51F99C4C.6050508@wwwdotorg.org>
Date: Wed, 31 Jul 2013 17:22:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: balbi@ti.com, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu
Subject: Re: [PATCH 0/6] USB tree changes for Tegra30 and Tegra114 USB Host
 support
References: <1375292522-7855-1-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1375292522-7855-1-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 11:41 AM, Tuomas Tynkkynen wrote:
> Hi all,
> 
> Here are the patches for the USB tree to enable USB Host support on Tegra30 and
> Tegra114. These are based on my and Mikko's cleanup patches that just got
> merged to Felipe's tree.

This series works fine for me on Dalmore. However, on Beaver, I see the
following:

[    2.428480] platform 7d008000.usb: Driver tegra-ehci requests probe
deferral

... which never seems to be resolved. You can take a look at my
linux-next_common branch to repro this. Does Beaver work for you?
