Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab3CAEmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 23:42:05 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:48461 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3CAEmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 23:42:03 -0500
Message-ID: <51303173.5060405@synopsys.com>
Date: Fri, 1 Mar 2013 10:11:23 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        "Gilad Ben-Yossef" <gilad@benyossef.com>, Helge Deller <deller@gmx.de>,
        "Mischa Jonker" <Mischa.Jonker@synopsys.com>
Subject: Re: [GIT PULL] arch/arc for v3.9-rc1
References: <51271703.8050107@synopsys.com>
In-Reply-To: <51271703.8050107@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2013 12:28 PM, Vineet Gupta wrote:
> Hi Linus,
> 
> I would like to introduce the Linux port to ARC Processors (from Synopsys) for
> 3.9-rc1. The patch-set has been discussed on the public lists since Nov and has
> received a fair bit of review, specially from Arnd, tglx, Al and other subsystem
> maintainers for DeviceTree, kgdb .....
> 
> The arch bits are in arch/arc, some asm-generic changes (acked by Arnd), a minor
> change to PARISC (acked by Helge).
> 
> The series is a touch bigger for a new port for 2 main reasons:
> 1. It enables a basic kernel in first sub-series and adds ptrace/kgdb/.. later
> 2. Some of the fallout of review (DeviceTree support, multi-platform-image
> support) were added on top of orig series, primarily to record the revision history.
> 
> Please consider pulling.
> 
> Thanks,
> Vineet

Hi Linus,

Did you get a chance to look at the patch series and is there anything in
particular which could be gating the merge.

Thanks,
Vineet
