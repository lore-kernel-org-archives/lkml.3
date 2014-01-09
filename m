Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaAIF6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 00:58:42 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59477 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbaAIF6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 00:58:41 -0500
Message-ID: <52CE3A8D.408@ti.com>
Date: Thu, 9 Jan 2014 11:28:37 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL 0/4] PHY: for 3.14
References: <1388076440-7620-1-git-send-email-kishon@ti.com> <52CCE0FD.80305@ti.com> <20140109033617.GA351@kroah.com>
In-Reply-To: <20140109033617.GA351@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 January 2014 09:06 AM, Greg KH wrote:
> On Wed, Jan 08, 2014 at 10:54:13AM +0530, Kishon Vijay Abraham I wrote:
>> Hi Greg,
>>
>> On Thursday 26 December 2013 10:17 PM, Kishon Vijay Abraham I wrote:
>>> Hi Greg,
>>>
>>> here's the patches for 3.14. It contains few fixes on phy-core and added a new
>>> PHY driver used by SATA in Marvell SoCs.
>>>
>>> Let me know if you need any changes.
>>>
>>> Thanks
>>> Kishon
>>>
>>> The following changes since commit 413541dd66d51f791a0b169d9b9014e4f56be13c:
>>>
>>>   Linux 3.13-rc5 (2013-12-22 13:08:32 -0800)
>>>
>>> are available in the git repository at:
>>>
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for_3.14
>>>
>>> for you to fetch changes up to e3eae85773ebd2165d19ca8661cca3b9c60b2ba1:
>>>
>>>   Phy: Add a PHY driver for Marvell MVEBU SATA PHY. (2013-12-24 23:52:58 +0530)
>>>
>>> ----------------------------------------------------------------
>>> Pull request for PHY subsystem contains few fixes in PHY-CORE mostly
>>> w.r.t PM and reference counting and also a new PHY driver used by SATA
>>> in Marvell SoC.
>>>
>>> ----------------------------------------------------------------
>>> Andrew Lunn (1):
>>>       Phy: Add a PHY driver for Marvell MVEBU SATA PHY.
>>>
>>> Felipe Balbi (1):
>>>       phy: core: properly handle failure of pm_runtime_get functions
>>>
>>> Kishon Vijay Abraham I (2):
>>>       phy: phy-core: increment refcounting variables only on 'success'
>>>       phy: phy-core.c: remove unnecessary initialization of local variables\
>>
>>
>> Will you be taking these patches?
> 
> Yes, sorry, catching up from my vacation backlog...

no problem, thanks.

-Kishon
> 
> greg k-h
> 

