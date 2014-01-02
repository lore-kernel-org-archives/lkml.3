Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaABKwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:52:38 -0500
Received: from top.free-electrons.com ([176.31.233.9]:45321 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751130AbaABKwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:52:34 -0500
Message-ID: <52C544E7.4000501@free-electrons.com>
Date: Thu, 02 Jan 2014 11:52:23 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Jason Cooper <jason@lakedaemon.net>,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: mvebu: Remove redundant code
References: <1388659296-21569-1-git-send-email-gregory.clement@free-electrons.com> <20140102114638.47457689@skate>
In-Reply-To: <20140102114638.47457689@skate>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2014 11:46, Thomas Petazzoni wrote:
> Dear Gregory CLEMENT,
> 
> On Thu,  2 Jan 2014 11:41:36 +0100, Gregory CLEMENT wrote:
>> In the commit b42285f66f871a989, Sebastian moved clock enable before
>> register access, but during the merge of the commit
>> 9f352f0e6c0fa2dc608812df "PCI: mvebu: Dynamically detect if the PEX
>> link is up to enable hot plug", the moved part was added back.
>>
>> This patch fixes this by removing the redundant code.
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> ---
>>  drivers/pci/host/pci-mvebu.c | 8 --------
>>  1 file changed, 8 deletions(-)
> 
> This has already been fixed by
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/pci/host/pci-mvebu.c?id=84f47190d6be1cb99cd4a680e1018080d93800a8.
> 

I didn't find it because I only looked for in my emails and I
wrongly assumed that the LAKML were in CC.

> Thanks!
> 
> Thomas
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
