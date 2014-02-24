Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaBXRQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:16:16 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:49692 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaBXRQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:16:14 -0500
Message-ID: <530B7E63.2070908@kernel.dk>
Date: Mon, 24 Feb 2014 09:16:19 -0800
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel@vger.kernel.org, Mike Miller <mike.miller@hp.com>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, iss_storagedev@hp.com,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 0/9] block: Use pci_enable_msix_range() instead of pci_enable_msix()
References: <cover.1392799751.git.agordeev@redhat.com> <20140221234613.GE29129@kernel.dk> <20140222093843.GB27897@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140222093843.GB27897@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-22 01:38, Alexander Gordeev wrote:
> On Fri, Feb 21, 2014 at 03:46:13PM -0800, Jens Axboe wrote:
>> On Wed, Feb 19 2014, Alexander Gordeev wrote:
>>> As result of deprecation of MSI-X/MSI enablement functions
>>> pci_enable_msix() and pci_enable_msi_block() all drivers
>>> using these two interfaces need to be updated to use the
>>> new pci_enable_msi_range() and pci_enable_msix_range()
>>> interfaces.
>>
>> Thanks. Applied 3-4, and 6-9 (didn't get the others).
>
> Oh, I just realized I posted outdated series, sorry for that :(
> Out of applied patch 4 is not needed and patch 9 needs a rework.
>
> Should I repost the whole series?

Send a revised series against the previous, since they are already 
committed.

-- 
Jens Axboe

