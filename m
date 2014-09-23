Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaIWAym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 20:54:42 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45046 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbaIWAyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 20:54:40 -0400
Date: Tue, 23 Sep 2014 10:53:39 +1000
From: Gavin Shan <gwshan@linux.vnet.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Joe Perches <joe@perches.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, shangw@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] powerpc: pci-ioda: Neatening
Message-ID: <20140923005339.GA7740@shangw>
Reply-To: Gavin Shan <gwshan@linux.vnet.ibm.com>
References: <cover.1411320262.git.joe@perches.com>
 <1411368977.16867.11.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411368977.16867.11.camel@concordia>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092300-0260-0000-0000-00000039B04F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 04:56:17PM +1000, Michael Ellerman wrote:
>On Sun, 2014-09-21 at 10:55 -0700, Joe Perches wrote:
>> printk calls should return void
>> 
>> Joe Perches (2):
>>   powerpc: pci-ioda: Remove unnecessary return value from printk
>>   powerpc: pci-ioda: Use a single function to emit logging messages
>
>Patches look good to me.
>

Patches look good to me too.

>Ben/Gavin, what do these macros give us over pr/dev_debug() ?
>

Those macros prints unified mapping information between
PE number and PCI device/bus.

Thanks,
Gavin

>cheers
>
>
>_______________________________________________
>Linuxppc-dev mailing list
>Linuxppc-dev@lists.ozlabs.org
>https://lists.ozlabs.org/listinfo/linuxppc-dev

