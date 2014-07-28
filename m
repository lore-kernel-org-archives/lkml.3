Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaG1Shf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:37:35 -0400
Received: from host171.canaca.com ([67.55.55.225]:39512 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaG1Shc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:37:32 -0400
X-Greylist: delayed 2275 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jul 2014 14:37:31 EDT
Message-ID: <5adf0339146a7b655a77053195aa892c.squirrel@mungewell.org>
In-Reply-To: <20140728174334.GD8982@core.coreip.homeip.net>
References: <1406566403-1436-1-git-send-email-dmurphy@ti.com>
    <20140728174334.GD8982@core.coreip.homeip.net>
Date: Mon, 28 Jul 2014 13:59:34 -0400
Subject: Re: [v2] input: drv260x: Add TI drv260x haptics driver
From: simon@mungewell.org
To: "Dan Murphy" <dmurphy@ti.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?iso-8859-1?Q?=22Michal_Mal=FD=22?= 
	<madcatxster@devoid-pointer.net>,
        "Elias Vanderstuyft" <elias.vds@gmail.com>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> The initial driver supports the devices
>> real time playback mode.  But the device
>> has additional wave patterns in ROM.
>
> As it presented the device appears to be a memoryless device, however
> you present it to the rest of the system as if it can support playback
> of multiple effects simultaneously, which is incorrect.
>
> My guess that you need to engage the memoryless input library to schedule
> handling multiple effects for your device, including ramping up, ramping
> down, stopping playback when effects runs out, etc.

Hi Dan,
Elias and Michal (cc'ed) are working on a kernel/userland library to
handle sending multiple force feedback signals to 'simple' devices,
perhaps you should engage with them.

Simon

