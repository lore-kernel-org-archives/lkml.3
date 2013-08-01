Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab3HANCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:02:24 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17887 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab3HANCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:02:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 01 Aug 2013 06:00:53 -0700
Message-ID: <51FA5C5A.2080900@nvidia.com>
Date: Thu, 1 Aug 2013 16:02:18 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/6] USB tree changes for Tegra30 and Tegra114 USB Host
 support
References: <1375292522-7855-1-git-send-email-ttynkkynen@nvidia.com> <51F99C4C.6050508@wwwdotorg.org>
In-Reply-To: <51F99C4C.6050508@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 02:22 AM, Stephen Warren wrote:
> On 07/31/2013 11:41 AM, Tuomas Tynkkynen wrote:
>> Hi all,
>>
>> Here are the patches for the USB tree to enable USB Host support on Tegra30 and
>> Tegra114. These are based on my and Mikko's cleanup patches that just got
>> merged to Felipe's tree.
> 
> This series works fine for me on Dalmore. However, on Beaver, I see the
> following:
> 
> [    2.428480] platform 7d008000.usb: Driver tegra-ehci requests probe
> deferral
> 
> ... which never seems to be resolved. You can take a look at my
> linux-next_common branch to repro this. Does Beaver work for you?
> 

The clock driver patch is missing from your branch. Applying it should fix that.
