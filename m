Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbaDBNy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:54:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:60673 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758600AbaDBNyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:54:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,780,1389772800"; 
   d="scan'208";a="513308886"
Message-ID: <533C1919.3010506@intel.com>
Date: Wed, 02 Apr 2014 17:05:13 +0300
From: Mathias Nyman <mathias.nyman@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 RESEND 4/4] xhci: Use pci_enable_msix_exact() instead
 of pci_enable_msix()
References: <cover.1394128952.git.agordeev@redhat.com> <606a52afdccf627b6273379b21daffc460b9559a.1394128952.git.agordeev@redhat.com> <20140306215646.GA23294@xanatos> <20140325142730.GA4518@dhcp-26-207.brq.redhat.com> <20140402114127.GA10007@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140402114127.GA10007@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 02:41 PM, Alexander Gordeev wrote:
> On Tue, Mar 25, 2014 at 03:27:30PM +0100, Alexander Gordeev wrote:
>> On Thu, Mar 06, 2014 at 01:56:46PM -0800, Sarah Sharp wrote:
>>> What do you mean by this sentence?  Are you fixing some bug in those two
>>> functions, or just cleaning up how they look?  Either way, this should
>>> really be two patches.
>> Hi Sarah,
>>
>> Any feedback on v2?
>

Hi

Thanks for the patches,
I'll  queue patch 2/2  for usb-linus once 3.15-rc1 comes out.

But I'm going to omit patch 1/2 because it doesn't really improve
code readability and doesn't change functionality.
At this stage I'd like to avoid extra patches as much as possible.
And besides, it adds one extra line of code

-Mathias
