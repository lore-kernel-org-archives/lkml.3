Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaLHKgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:36:18 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:55316 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaLHKgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:36:17 -0500
X-IronPort-AV: E=Sophos;i="5.07,537,1413244800"; 
   d="scan'208";a="201731178"
Message-ID: <54857F1E.1010506@citrix.com>
Date: Mon, 8 Dec 2014 10:36:14 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/4] dma: add dma_get_required_mask_from_max_pfn()
References: <1417788483-662-1-git-send-email-david.vrabel@citrix.com> <1417788483-662-2-git-send-email-david.vrabel@citrix.com> <20141205213113.GB3012@kroah.com>
In-Reply-To: <20141205213113.GB3012@kroah.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/14 21:31, Greg Kroah-Hartman wrote:
> On Fri, Dec 05, 2014 at 02:08:00PM +0000, David Vrabel wrote:
>> A generic dma_get_required_mask() is useful even for architectures (such
>> as ia64) that define ARCH_HAS_GET_REQUIRED_MASK.
>>
>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
>> Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> ---
>>  drivers/base/platform.c     |   10 ++++++++--
> 
> Is this why you sent this to me?  The x86 maintainers should handle this
> patch set, not me for a tiny 8 lines in just one of the files, sorry.

This series will be merged via the Xen tree, but this patch still needs
your review or ack.

David
