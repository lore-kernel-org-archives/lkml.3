Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958Ab3AQFM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 00:12:28 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:37775 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341Ab3AQFM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:12:26 -0500
Message-ID: <50F7878C.4020800@synopsys.com>
Date: Thu, 17 Jan 2013 10:39:32 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC Patch v1 52/55] ARC: Support for single cycle Close Coupled
 Mem (CCM)
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <1352720953-24321-22-git-send-email-vgupta@synopsys.com> <201211121410.02682.arnd@arndb.de>
In-Reply-To: <201211121410.02682.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012 07:40 PM, Arnd Bergmann wrote:
> On Monday 12 November 2012, Vineet.Gupta1@synopsys.com wrote:
>> +config ARC_DCCM_SZ
>> +       int "DCCM Size in KB"
>> +       default "64"
>> +       depends on ARC_HAS_DCCM
>> +
>> +config ARC_DCCM_BASE
>> +       hex "DCCM map address"
>> +       default "0xA0000000"
>> +       depends on ARC_HAS_DCCM
>> +
> 
> I suppose these should be configured from the device tree at boot time, not
> during the build process.
> 
> I also wonder if the interface should be unified with what we use for
> accessing the sram on some of the ARM platforms.
> 
> 	Arnd
> 

Actually in ARC Port these are used in Linker script to layout the kernel
code/data at the addr where these hardware blocks are wired up. So can't be done
at runtime.

-Vineet
