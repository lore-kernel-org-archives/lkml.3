Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaJUKHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:07:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51523 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbaJUKHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:07:35 -0400
Message-ID: <54463063.80207@ti.com>
Date: Tue, 21 Oct 2014 15:37:31 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] Add DRA7xx CPSW Ethernet support in Device Tree
References: <1413885661-4850-1-git-send-email-mugunthanvnm@ti.com>
In-Reply-To: <1413885661-4850-1-git-send-email-mugunthanvnm@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth

On Tuesday 21 October 2014 03:30 PM, Mugunthan V N wrote:
> Adding device tree entry for CPSW to make it work in Dual EMAC mode.
> These patches were tested with DRA7 hwmod patches on top of linux-next.
> Patches are tested on top of Nishanth's PM tree for v3.17 [1] and pushed
> my tree to [2].
> 
> Did a boot test with CPSW and ping test with suspend/resume, the boot logs
> on DRA7xx EVM are posted at [3]
> 
> [1] git://github.com/nmenon/linux-2.6-playground.git testing/v3.17/cpu-idle-suspend-dra7-omap5-framework
> [2] git://git.ti.com/~mugunthanvnm/ti-linux-kernel/linux.git v3.17/dra7-evm-cpsw-v3
> [3] http://pastebin.ubuntu.com/8613072/
> 
> Changes from v2:
> * Changed pinctrl comments to hold mode0-name.mode-selected-name
> * Changes slave numbers in the pinctrl comments
> * Added cpsw and cpts clocks
> 

I have not added support for dra72x-evm as it has only slave no 2 pinned
out and having issues with bringing up the interface, need some more
time to submit the patch, in the mean time I have submitted dra7-evm
support only so that people can use dra7-evm on linux-next.

Regards
Mugunthan V N
