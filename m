Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3AQWSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:18:48 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46746 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3AQWSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:18:46 -0500
Message-ID: <50F878C3.9030002@wwwdotorg.org>
Date: Thu, 17 Jan 2013 15:18:43 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: balbi@ti.com
CC: Venu Byravarasu <vbyravarasu@nvidia.com>, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 4/4] usb: Add APIs to access host registers from Tegra
 PHY
References: <1358411292-12288-1-git-send-email-vbyravarasu@nvidia.com> <20130117090255.GD10814@arwen.pp.htv.fi>
In-Reply-To: <20130117090255.GD10814@arwen.pp.htv.fi>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 02:02 AM, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Jan 17, 2013 at 01:58:12PM +0530, Venu Byravarasu wrote:
>> As Tegra PHY driver need to access one of the Host registers, 
>> added few APIs to ehci tegra driver.
>> 
>> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> 
> Stephen is this another of those patches you're gonna take care of 
> yourself ?

Yes; in kernel 3.9, I believe I need to take any significant Tegra
EHCI or PHY patches through the Tegra tree due to the need to change
the Tegra device trees in lock-step with some of the code changes, and
other Tegra-related changes also changing the USB-related nodes in
device tree e.g. to add clocks properties.

Hopefully we get enough USB patches into 3.9 that the dependencies are
then removed, and we can revert back to the usual merging path in 3.10...
