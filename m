Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab3LVHry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 02:47:54 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:55297 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab3LVHrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 02:47:52 -0500
Message-ID: <52B69925.8030409@compulab.co.il>
Date: Sun, 22 Dec 2013 09:47:49 +0200
From: Denis Turischev <denis.turischev@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v1] xhci: Switch Intel Lynx Point ports to EHCI on shutdown
References: <52B31EDA.60908@compulab.co.il> <52B327D5.3080805@compulab.co.il> <20131219182110.GC3573@xanatos> <52B41EC7.1070704@compulab.co.il> <20131220234547.GC2835@xanatos>
In-Reply-To: <20131220234547.GC2835@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: -unknown-@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2013 01:45 AM, Sarah Sharp wrote:
> On Fri, Dec 20, 2013 at 12:41:11PM +0200, Denis Turischev wrote:
>>> Also, which kernel are you experiencing this issue on?  In 3.12, I
>>> queued a separate patch to deal with spurious reboot issues on Lynx
>>> Point:
>>>
>>> commit 638298dc66ea36623dbc2757a24fc2c4ab41b016
>> Sorry, I indeed tested not on the latest kernel version, Ubuntu 3.13-rc3 has this patch and it works
>> for me.
> 
> What does "Ubuntu 3.13-rc3" mean?  Where did you get your kernel from?
Latest Ubuntu development kernel based on mainline 3.13-rc3.
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.13-rc3-trusty/
> 
> Also, do you have an HP system, or is this a different vendor?
No, it's not HP system, it's Compulab's IntensePC-2 with Phoenix BIOS.
> 
> Sarah Sharp
> 

