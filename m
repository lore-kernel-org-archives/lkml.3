Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbaGIOLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:11:49 -0400
Received: from smtp.citrix.com ([66.165.176.89]:53419 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbaGIOLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:11:48 -0400
X-IronPort-AV: E=Sophos;i="5.01,631,1400025600"; 
   d="scan'208";a="150968789"
Message-ID: <53BD4D7C.70901@citrix.com>
Date: Wed, 9 Jul 2014 15:11:08 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <konrad@kernel.org>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [PATCH v3 4/7] xen/pciback: Implement PCI reset slot
 or bus with 'do_flr' SysFS attribute
References: <1404845909-13563-1-git-send-email-konrad@kernel.org>	<1404845909-13563-5-git-send-email-konrad@kernel.org>	<53BC324B.5090600@citrix.com>	<20140708184626.GA15548@laptop.dumpdata.com> <53BD364A.5020703@citrix.com>
In-Reply-To: <53BD364A.5020703@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/14 13:32, David Vrabel wrote:
> On 08/07/14 19:46, Konrad Rzeszutek Wilk wrote:
>> On Tue, Jul 08, 2014 at 07:02:51PM +0100, David Vrabel wrote:
>>>
>>> Not sure I like this new interface.  I solved this by adding a new reset
>>> file that looked like the regular one the pci would have if it supported
>>> FLR.  I'm fairly sure I posted a series for this.  Was there a reason
>>> you didn't do this?
>>
>> It did not work.
>>
>> During bootup kobject would complain about a secondary 'reset' SysFS
>> on the PCI device.
[...]
> 
> I would consider:

Or try the v2 of the patch which defers creating the sysfs to the late init.

David
