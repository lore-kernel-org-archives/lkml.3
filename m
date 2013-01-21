Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab3AUFur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 00:50:47 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:42286 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3AUFup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 00:50:45 -0500
Message-ID: <50FCD725.80904@synopsys.com>
Date: Mon, 21 Jan 2013 11:20:29 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ralf Baechle <ralf@linux-mips.org>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <arnd@arndb.de>
Subject: Re: [PATCH v2 00/76] Synopsys ARC Linux kernel Port
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <50FB8B71.6050207@zytor.com>
In-Reply-To: <50FB8B71.6050207@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 January 2013 11:45 AM, H. Peter Anvin wrote:
> On 01/18/2013 04:24 AM, Vineet Gupta wrote:
>> This patchset based off-of 3.8-rc4, adds the Linux kernel port to ARC700
>> processor family (750D and 770D) from Synopsys. I would be greatful for
>> further review and feedback.
> 
> One thing: ARC, as I understand it, is a whole family of architectures, which
> mostly have in common their origin at Synopsys.  

ARC has had a long history - as a startup in 90's. There used to be ARCTanget
Instruction set (and cores A4,A5... based on that) which 10 years ago got
deprecated by current ARCompact ISA (600 / 700 cores). So yes it is a family of
architectures - but all we care about is the ARCompact and 600/700 at Synopsys.

However, I don't think there were sub-architectures or forks which floated around.
The MIPS "ARC" seems to be some sort of firmware standard, but not  related to
ARC: Ralf would you care to shed some light ? I don't know of any ARC arch other
than these.

> Can we make this arch/arc700
> since that is what it is?
> 
>     -hpa
> 

As of now yes, but in near future we may have a new Instruction Set and cores
based on that - so it will be better if we keep a non specific name.

Thx,
-Vineet
