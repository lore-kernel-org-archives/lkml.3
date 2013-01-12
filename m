Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab3ALAn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 19:43:59 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37946 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3ALAn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 19:43:58 -0500
Message-ID: <50F0B1C8.400@wwwdotorg.org>
Date: Fri, 11 Jan 2013 17:43:52 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Venu Byravarasu <vbyravarasu@nvidia.com>, Felipe Balbi <balbi@ti.com>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, sjg@chromium.org, olof@lixom.net,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: tegra: Add new DT property to USB node.
References: <50CF89AF.3000308@wwwdotorg.org> <Pine.LNX.4.44L0.1212171704060.1409-100000@iolanthe.rowland.org> <20130112001414.GA21909@kroah.com>
In-Reply-To: <20130112001414.GA21909@kroah.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 05:14 PM, Greg KH wrote:
> On Mon, Dec 17, 2012 at 05:04:41PM -0500, Alan Stern wrote:
>> On Mon, 17 Dec 2012, Stephen Warren wrote:
>>
>>> On 12/13/2012 11:59 PM, Venu Byravarasu wrote:
>>>> As Tegra USB host driver is using instance number for resetting
>>>> PORT0 twice, adding a new DT property for handling this.
>>>
>>> Alan, Greg, Felip,e
>>>
>>> This series looks fine to me.
>>>
>>> I'd like to take all the Tegra-related USB patches through the Tegra
>>> tree for 3.9 if possible (so I'm looking for your acks here). I believe
>>> Venu plans to significantly clean up the EHCI/PHY driver split for
>>> Tegra, rework the drivers, and add support for Tegra30 in addition to
>>> Tegra20. Some of this requires changes to some Tegra board files and
>>> device trees to maintain "git bisect" I don't know for sure yet, but I
>>> believe that rework may also end up conflicting with other clock-related
>>> rework that will show up for Tegra in 3.9. Are you OK with this? I'll
>>> certainly look for your review/acks on the patches before picking them
>>> up though.
>>
>> Regarding the changes to drivers/usb/host/ehci-tegra.c:
>>
>> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> That's fine with me as well, feel free to think that I have now dropped
> all tegra-related patches from my queue, you can take them all :)

Thanks, applied to Tegra's for-3.9/usb branch.

